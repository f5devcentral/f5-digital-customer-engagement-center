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

  #custom_data = base64encode(local.user_data)

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

# Run Startup Scripts
resource "azurerm_virtual_machine_extension" "docker" {
  name                 = format("%s-backend-onboard-%s", var.projectPrefix, var.buildSuffix)
  virtual_machine_id   = azurerm_linux_virtual_machine.backend.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "DockerExtension"
  type_handler_version = "1.0"

  tags = {
    Name  = format("%s-backend-docker-%s", var.projectPrefix, var.buildSuffix)
    Owner = var.resourceOwner
  }
}

resource "azurerm_virtual_machine_extension" "onboard" {
  name                 = format("%s-backend-onboard-%s", var.projectPrefix, var.buildSuffix)
  virtual_machine_id   = azurerm_linux_virtual_machine.backend.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "script": "${base64encode(local.user_data)}"
    }
  SETTINGS

  depends_on = [azurerm_virtual_machine_extension.docker]

  tags = {
    Name  = format("%s-backend-onboard-%s", var.projectPrefix, var.buildSuffix)
    Owner = var.resourceOwner
  }
}
