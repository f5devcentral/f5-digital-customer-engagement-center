############################# Provider ###########################

provider "azurerm" {
  features {}
}

# Create a random id
resource "random_id" "buildSuffix" {
  byte_length = 2
}

############################ Resource Groups ############################

# Create Resource Groups
resource "azurerm_resource_group" "rg" {
  for_each = var.vnets
  name     = format("%s-rg-%s-%s", var.projectPrefix, each.key, random_id.buildSuffix.hex)
  location = each.value["location"]

  tags = {
    Name = format("%s-rg-%s-%s", var.resourceOwner, each.key, random_id.buildSuffix.hex)
  }
}

############################ VNets ############################

# Create VNets
module "network" {
  for_each            = var.vnets
  source              = "Azure/vnet/azurerm"
  resource_group_name = azurerm_resource_group.rg[each.key].name
  vnet_name           = format("%s-vnet-%s-%s", var.projectPrefix, each.key, random_id.buildSuffix.hex)
  address_space       = each.value["cidr"]
  subnet_prefixes     = each.value["subnetPrefixes"]
  subnet_names        = each.value["subnetNames"]

  tags = {
    Name = format("%s-vnet-%s-%s", var.resourceOwner, each.key, random_id.buildSuffix.hex)
  }

  depends_on = [azurerm_resource_group.rg]
}

############################ VNet Peering ############################

locals {
  spokeHubPeerings = {
    appWest = {
    }
    appEast = {
    }
  }
}

# Create hub to spoke peerings
resource "azurerm_virtual_network_peering" "hubToSpoke" {
  for_each                  = local.spokeHubPeerings
  name                      = format("hub-to-%s", each.key)
  resource_group_name       = azurerm_resource_group.rg["shared"].name
  virtual_network_name      = module.network["shared"].vnet_name
  remote_virtual_network_id = module.network[each.key].vnet_id
  depends_on                = [module.network]
}

# Create spoke to hub peerings
resource "azurerm_virtual_network_peering" "spokeToHub" {
  for_each                  = local.spokeHubPeerings
  name                      = format("%s-to-hub", each.key)
  resource_group_name       = azurerm_resource_group.rg[each.key].name
  virtual_network_name      = module.network[each.key].vnet_name
  remote_virtual_network_id = module.network["shared"].vnet_id
  depends_on                = [module.network]
}

############################ Security Groups - Jumphost, Web Servers ############################

# Allow webserver access
resource "azurerm_network_security_group" "webserver" {
  for_each            = var.vnets
  name                = format("%s-nsg-webservers-%s", var.projectPrefix, random_id.buildSuffix.hex)
  location            = azurerm_resource_group.rg[each.key].location
  resource_group_name = azurerm_resource_group.rg[each.key].name

  security_rule {
    name                       = "allow_SSH"
    description                = "Allow SSH access"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow_HTTP"
    description                = "Allow HTTP access"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow_HTTPS"
    description                = "Allow HTTPS access"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Name = format("%s-nsg-webservers-%s", var.resourceOwner, random_id.buildSuffix.hex)
  }
}

############################ Compute ############################

# Onboard Scripts
locals {
  user_data = templatefile("${path.module}/templates/cloud-config.yml", {
    index_html      = replace(file("${path.module}/../../../../../modules/common/files/backend/index.html"), "/[\\n\\r]/", "")
    f5_logo_rgb_svg = base64gzip(file("${path.module}/../../../../../modules/common/files/backend/f5-logo-rgb.svg"))
    styles_css      = base64gzip(file("${path.module}/../../../../../modules/common/files/backend/styles.css"))
  })
}

# Create VM Scale Set for West region app servers
resource "azurerm_linux_virtual_machine_scale_set" "appWest" {
  name                 = format("%s-vmss-appWest-%s", var.projectPrefix, random_id.buildSuffix.hex)
  location             = azurerm_resource_group.rg["appWest"].location
  resource_group_name  = azurerm_resource_group.rg["appWest"].name
  sku                  = "Standard_B2ms"
  instances            = var.num_servers
  admin_username       = var.adminName
  computer_name_prefix = "${var.projectPrefix}appWest"
  custom_data          = base64encode(local.user_data)

  admin_ssh_key {
    public_key = var.sshPublicKey
    username   = var.adminName
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  network_interface {
    name    = "external"
    primary = true
    ip_configuration {
      name      = "primary"
      primary   = true
      subnet_id = module.network["appWest"].vnet_subnets[0]
      public_ip_address {
        name = "pip"
      }
    }
  }

  tags = {
    Name = format("%s-vmss-appWest-%s", var.resourceOwner, random_id.buildSuffix.hex)
  }
}

# Create VM Scale Set for East region app servers
resource "azurerm_linux_virtual_machine_scale_set" "appEast" {
  name                 = format("%s-vmss-appEast-%s", var.projectPrefix, random_id.buildSuffix.hex)
  location             = azurerm_resource_group.rg["appEast"].location
  resource_group_name  = azurerm_resource_group.rg["appEast"].name
  sku                  = "Standard_B2ms"
  instances            = var.num_servers
  admin_username       = var.adminName
  computer_name_prefix = "${var.projectPrefix}appEast"
  custom_data          = base64encode(local.user_data)

  admin_ssh_key {
    public_key = var.sshPublicKey
    username   = var.adminName
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  network_interface {
    name    = "external"
    primary = true
    ip_configuration {
      name      = "primary"
      primary   = true
      subnet_id = module.network["appEast"].vnet_subnets[0]
      public_ip_address {
        name = "pip"
      }
    }
  }

  tags = {
    Name = format("%s-vmss-appEast-%s", var.resourceOwner, random_id.buildSuffix.hex)
  }
}
