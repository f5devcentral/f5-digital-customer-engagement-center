# Terraform Version Pinning
terraform {
  required_version = "~> 0.14"
  required_providers {
    azurerm = "~> 2"
  }
}

# Create Public IP
resource "azurerm_public_ip" "this" {
  count               = var.public_address ? 1 : 0
  name                = format("%s-backend-pip-%s", var.projectPrefix, var.buildSuffix)
  location            = var.azureLocation
  resource_group_name = var.azureResourceGroup
  allocation_method   = "Static"

  tags = {
    Name  = format("%s-backend-pip-%s", var.projectPrefix, var.buildSuffix)
    Owner = var.resourceOwner
  }
}

# Create NIC
resource "azurerm_network_interface" "this" {
  name                = format("%s-backend-nic-%s", var.projectPrefix, var.buildSuffix)
  location            = var.azureLocation
  resource_group_name = var.azureResourceGroup

  ip_configuration {
    name                          = "primary"
    subnet_id                     = var.subnet
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_address ? azurerm_public_ip.this[0].id : null
  }

  tags = {
    Name  = format("%s-backend-nic-%s", var.projectPrefix, var.buildSuffix)
    Owner = var.resourceOwner
  }
}

# Associate security groups with NIC
resource "azurerm_network_interface_security_group_association" "this" {
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = var.securityGroup
}

# Onboarding script
locals {
  user_data = coalesce(var.user_data, templatefile("${path.module}/templates/cloud-config.yml", {
    f5_logo_rgb_svg = base64gzip(file("${path.module}/files/f5-logo-rgb.svg"))
    styles_css      = base64gzip(file("${path.module}/files/styles.css"))
  }))
}

# Create VM
resource "azurerm_linux_virtual_machine" "backend" {
  name                  = format("%s-backend-%s", var.projectPrefix, var.buildSuffix)
  location              = var.azureLocation
  resource_group_name   = var.azureResourceGroup
  network_interface_ids = [azurerm_network_interface.this.id]
  size                  = var.instanceType
  admin_username        = var.adminAccountName
  custom_data           = base64encode(local.user_data)

  admin_ssh_key {
    username   = var.adminAccountName
    public_key = var.ssh_key
  }

  os_disk {
    name                 = format("%s-backend-disk-%s", var.projectPrefix, var.buildSuffix)
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
    Name  = format("%s-backend-%s", var.projectPrefix, var.buildSuffix)
    Owner = var.resourceOwner
  }
}
