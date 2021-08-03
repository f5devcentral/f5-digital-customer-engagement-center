# Terraform Version Pinning
terraform {
  required_version = "~> 0.14"
  required_providers {
    azurerm = "~> 2"
  }
}

# Create Public IP
resource "azurerm_public_ip" "mgmtPip" {
  name                = format("%s-jumphost-pip-%s", var.projectPrefix, var.buildSuffix)
  location            = var.azureLocation
  sku                 = "Standard"
  resource_group_name = var.azureResourceGroup
  allocation_method   = "Static"

  tags = {
    Name      = format("%s-jumphost-pip-%s", var.resourceOwner, var.buildSuffix)
    Terraform = "true"
  }
}

# Create NIC
resource "azurerm_network_interface" "mgmtNic" {
  name                = format("%s-jumphost-nic-%s", var.projectPrefix, var.buildSuffix)
  location            = var.azureLocation
  resource_group_name = var.azureResourceGroup

  ip_configuration {
    name                          = "primary"
    subnet_id                     = var.mgmtSubnet
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mgmtPip.id
  }

  tags = {
    Name      = format("%s-jumphost-nic-%s", var.resourceOwner, var.buildSuffix)
    Terraform = "true"
  }
}

# Associate security groups with NIC
resource "azurerm_network_interface_security_group_association" "this" {
  network_interface_id      = azurerm_network_interface.mgmtNic.id
  network_security_group_id = var.securityGroup
}

# Onboarding script
locals {
  onboard = templatefile("${path.module}/templates/startup.sh.tpl", {
    repositories         = var.repositories
    coderAccountPassword = var.coderAccountPassword
    terraformVersion     = var.terraformVersion
  })
}

# Create VM
resource "azurerm_linux_virtual_machine" "jumphost" {
  name                  = format("%s-jumphost-%s", var.projectPrefix, var.buildSuffix)
  location              = var.azureLocation
  resource_group_name   = var.azureResourceGroup
  network_interface_ids = [azurerm_network_interface.mgmtNic.id]
  size                  = var.instanceType
  admin_username        = var.adminAccountName

  admin_ssh_key {
    username   = var.adminAccountName
    public_key = file(var.keyName)
  }

  #custom_data = base64encode(local.onboard)

  os_disk {
    name                 = format("%s-jumphost-disk-%s", var.projectPrefix, var.buildSuffix)
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
    Name      = format("%s-jumphost-%s", var.resourceOwner, var.buildSuffix)
    Terraform = "true"
  }
}

# Run Startup Script
resource "azurerm_virtual_machine_extension" "onboard" {
  name                 = format("%s-jumphost-onboard-%s", var.projectPrefix, var.buildSuffix)
  virtual_machine_id   = azurerm_linux_virtual_machine.jumphost.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "script": "${base64encode(local.onboard)}"
    }
  SETTINGS

  tags = {
    Name      = format("%s-jumphost-onboard-%s", var.resourceOwner, var.buildSuffix)
    Terraform = "true"
  }
}
