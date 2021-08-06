############################ Locals for Vnets ############################

locals {
  vnets = {
    bu11 = {
      location       = var.azureLocation
      addressSpace   = ["10.1.0.0/16"]
      subnetPrefixes = ["10.1.10.0/24", "10.1.52.0/24"]
      subnetNames    = ["external", "internal"]
    }
    bu12 = {
      location       = var.azureLocation
      addressSpace   = ["10.1.0.0/16"]
      subnetPrefixes = ["10.1.10.0/24", "10.1.52.0/24"]
      subnetNames    = ["external", "internal"]
    }
    bu13 = {
      location       = var.azureLocation
      addressSpace   = ["10.1.0.0/16"]
      subnetPrefixes = ["10.1.10.0/24", "10.1.52.0/24"]
      subnetNames    = ["external", "internal"]
    }
  }
}

############################ Resource Groups ############################

# Create Resource Groups
resource "azurerm_resource_group" "rg" {
  for_each = local.vnets
  name     = format("%s-rg-%s-%s", var.projectPrefix, each.key, var.buildSuffix)
  location = each.value["location"]

  tags = {
    Name      = format("%s-rg-%s-%s", var.resourceOwner, each.key, var.buildSuffix)
    Terraform = "true"
  }
}

############################ VNets ############################

# Create VNets
module "network" {
  for_each            = local.vnets
  source              = "Azure/vnet/azurerm"
  resource_group_name = azurerm_resource_group.rg[each.key].name
  vnet_name           = format("%s-vnet-%s-%s", var.projectPrefix, each.key, var.buildSuffix)
  address_space       = each.value["addressSpace"]
  subnet_prefixes     = each.value["subnetPrefixes"]
  subnet_names        = each.value["subnetNames"]

  tags = {
    Name      = format("%s-vnet-%s-%s", var.resourceOwner, each.key, var.buildSuffix)
    Terraform = "true"
  }
  # Emes - I needed this dependency to get the module to function
  # TODO: @JeffGiroux - is this necessary or because of my Azure perms issue?
  depends_on = [
    azurerm_resource_group.rg,
  ]
}

############################ Security Groups - Jumphost, Web Servers ############################

locals {
  jumphosts = {
    bu11 = {
      subnet = module.network["bu11"].vnet_subnets[0]
      create = true
    }
    bu12 = {
      subnet = module.network["bu12"].vnet_subnets[0]
      create = false
    }
    bu13 = {
      subnet = module.network["bu13"].vnet_subnets[0]
      create = false
    }
  }

  webservers = {
    bu11 = {
      subnet = module.network["bu11"].vnet_subnets[1]
    }
    bu12 = {
      subnet = module.network["bu12"].vnet_subnets[1]
    }
    bu13 = {
      subnet = module.network["bu13"].vnet_subnets[1]
    }
  }
}

# Allow jumphost access
resource "azurerm_network_security_group" "jumphost" {
  for_each            = local.jumphosts
  name                = format("%s-nsg-jumphost-%s", var.projectPrefix, var.buildSuffix)
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

  tags = {
    Name      = format("%s-nsg-jumphost-%s", var.resourceOwner, var.buildSuffix)
    Terraform = "true"
  }
}

# Allow webserver access
resource "azurerm_network_security_group" "webserver" {
  for_each            = local.webservers
  name                = format("%s-nsg-webservers-%s", var.projectPrefix, var.buildSuffix)
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

  tags = {
    Name      = format("%s-nsg-webservers-%s", var.resourceOwner, var.buildSuffix)
    Terraform = "true"
  }
}

############################ Compute ############################

# Create jumphost instances
module "jumphost" {
  for_each           = { for k, v in local.jumphosts : k => v if v.create }
  source             = "../../../../modules/azure/terraform/jumphost/"
  projectPrefix      = var.projectPrefix
  buildSuffix        = var.buildSuffix
  resourceOwner      = var.resourceOwner
  azureResourceGroup = azurerm_resource_group.rg[each.key].name
  azureLocation      = azurerm_resource_group.rg[each.key].location
  ssh_key            = var.ssh_key
  mgmtSubnet         = each.value["subnet"]
  securityGroup      = azurerm_network_security_group.jumphost[each.key].id
}

# Create webserver instances
module "webserver" {
  for_each           = local.webservers
  source             = "../../../../modules/azure/terraform/webServer/"
  projectPrefix      = var.projectPrefix
  buildSuffix        = var.buildSuffix
  resourceOwner      = var.resourceOwner
  azureResourceGroup = azurerm_resource_group.rg[each.key].name
  azureLocation      = azurerm_resource_group.rg[each.key].location
  ssh_key            = var.ssh_key
  subnet             = each.value["subnet"]
  securityGroup      = azurerm_network_security_group.webserver[each.key].id
}
