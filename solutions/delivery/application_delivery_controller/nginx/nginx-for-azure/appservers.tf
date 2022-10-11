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
  instances            = var.numServers
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
      subnet_id = azurerm_subnet.appWest.id
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
  instances            = var.numServers
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
      subnet_id = azurerm_subnet.appEast.id
      public_ip_address {
        name = "pip"
      }
    }
  }
  tags = {
    Name = format("%s-vmss-appEast-%s", var.resourceOwner, random_id.buildSuffix.hex)
  }
}

############################ Autoscaling Monitor and Settings ############################

# Create Autoscale settings for West region app servers
resource "azurerm_monitor_autoscale_setting" "appWest" {
  name                = "autoscale"
  resource_group_name = azurerm_resource_group.appWest.name
  location            = azurerm_resource_group.appWest.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.appWest.id
  profile {
    name = "default"
    capacity {
      default = 1
      minimum = 1
      maximum = 3
    }
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.appWest.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.appWest.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
  notification {
    webhook {
      service_uri = "https://${azurerm_windows_function_app.main.default_hostname}/api/vmAutoscaleNginxConfig?code=${data.azurerm_function_app_host_keys.main.default_function_key}"
    }
  }
}

# Create Autoscale settings for East region app servers
resource "azurerm_monitor_autoscale_setting" "appEast" {
  name                = "autoscale"
  resource_group_name = azurerm_resource_group.appEast.name
  location            = azurerm_resource_group.appEast.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.appEast.id
  profile {
    name = "default"
    capacity {
      default = 1
      minimum = 1
      maximum = 3
    }
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.appEast.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.appEast.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
  notification {
    webhook {
      service_uri = "https://${azurerm_windows_function_app.main.default_hostname}/api/vmAutoscaleNginxConfig?code=${data.azurerm_function_app_host_keys.main.default_function_key}"
    }
  }
}
