############################ Locals ############################

# Onboard Scripts
locals {
  user_data = templatefile("${path.module}/templates/cloud-config.yml", {
    index_html      = replace(file("${path.module}/../../../../../modules/common/files/backend/index.html"), "/[\\n\\r]/", "")
    f5_logo_rgb_svg = base64gzip(file("${path.module}/../../../../../modules/common/files/backend/f5-logo-rgb.svg"))
    styles_css      = base64gzip(file("${path.module}/../../../../../modules/common/files/backend/styles.css"))
  })
}

############################ Compute - autoscaling ############################

# Create VM Scale Set for West region app servers
resource "azurerm_linux_virtual_machine_scale_set" "appWest" {
  name                 = format("%s-vmss-appWest-%s", var.projectPrefix, random_id.buildSuffix.hex)
  location             = azurerm_resource_group.appWest.location
  resource_group_name  = azurerm_resource_group.appWest.name
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
      name                                   = "primary"
      primary                                = true
      subnet_id                              = azurerm_subnet.appWest.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.appWest.id]
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
  location             = azurerm_resource_group.appEast.location
  resource_group_name  = azurerm_resource_group.appEast.name
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
      name                                   = "primary"
      primary                                = true
      subnet_id                              = azurerm_subnet.appEast.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.appEast.id]
      public_ip_address {
        name = "pip"
      }
    }
  }

  tags = {
    Name = format("%s-vmss-appEast-%s", var.resourceOwner, random_id.buildSuffix.hex)
  }
}
