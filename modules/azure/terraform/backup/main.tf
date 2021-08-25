# Terraform Version Pinning
terraform {
  required_version = "~> 0.14"
  required_providers {
    azurerm = "~> 2"
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
  onboard = templatefile("${path.module}/templates/startup.sh.tpl", {
    startupCommand = var.startupCommand
  })
}

# Create VM
resource "azurerm_linux_virtual_machine" "backend" {
  name                  = format("%s-backend-%s", var.projectPrefix, var.buildSuffix)
  location              = var.azureLocation
  resource_group_name   = var.azureResourceGroup
  network_interface_ids = [azurerm_network_interface.this.id]
  size                  = var.instanceType
  admin_username        = var.adminAccountName

  admin_ssh_key {
    username   = var.adminAccountName
    public_key = var.ssh_key
  }

  #custom_data = base64encode(local.onboard)

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

# Run Startup Script
resource "azurerm_virtual_machine_extension" "onboard" {
  name                 = format("%s-backend-onboard-%s", var.projectPrefix, var.buildSuffix)
  virtual_machine_id   = azurerm_linux_virtual_machine.backend.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "script": "${base64encode(local.onboard)}"
    }
  SETTINGS

  tags = {
    Name  = format("%s-backend-onboard-%s", var.projectPrefix, var.buildSuffix)
    Owner = var.resourceOwner
  }
}
