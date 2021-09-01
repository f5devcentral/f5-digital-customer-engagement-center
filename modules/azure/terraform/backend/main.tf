# Terraform Version Pinning
terraform {
  required_version = "~> 0.14"
  required_providers {
    azurerm = "~> 2"
  }
}

locals {
  user_data = coalesce(var.user_data, templatefile("${path.module}/templates/cloud-config.yml", {
    index_html      = replace(file("${path.module}/../../../common/files/backend/index.html"), "/[\\n\\r]/", "")
    f5_logo_rgb_svg = base64gzip(file("${path.module}/../../../common/files/backend/f5-logo-rgb.svg"))
    styles_css      = base64gzip(file("${path.module}/../../../common/files/backend/styles.css"))
  }))
  name = coalesce(var.name, format("%s-backend-%s", var.projectPrefix, var.buildSuffix))
  zone = coalesce(var.zone, random_shuffle.zones.result[0])
}

resource "random_shuffle" "zones" {
  input = var.azureZones
  keepers = {
    azureLocation = var.azureLocation
  }
}

# Create Public IP
resource "azurerm_public_ip" "this" {
  count               = var.public_address ? 1 : 0
  name                = local.name
  location            = var.azureLocation
  resource_group_name = var.azureResourceGroup
  sku                 = "Standard"
  allocation_method   = "Static"
  availability_zone   = local.zone
  tags = {
    Owner = var.resourceOwner
  }
}

# Create NIC
resource "azurerm_network_interface" "this" {
  name                = local.name
  location            = var.azureLocation
  resource_group_name = var.azureResourceGroup
  ip_configuration {
    name                          = "primary"
    subnet_id                     = var.subnet
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_address ? azurerm_public_ip.this[0].id : null
  }
  tags = {
    Owner = var.resourceOwner
  }
}

# Associate security groups with NIC
resource "azurerm_network_interface_security_group_association" "this" {
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = var.securityGroup
}

# Create VM
resource "azurerm_linux_virtual_machine" "backend" {
  name                  = local.name
  location              = var.azureLocation
  resource_group_name   = var.azureResourceGroup
  network_interface_ids = [azurerm_network_interface.this.id]
  size                  = var.instanceType
  admin_username        = var.adminAccountName
  custom_data           = base64encode(local.user_data)
  zone                  = local.zone
  admin_ssh_key {
    username   = var.adminAccountName
    public_key = var.ssh_key
  }
  os_disk {
    name                 = local.name
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  tags = {
    Owner = var.resourceOwner
  }
}
