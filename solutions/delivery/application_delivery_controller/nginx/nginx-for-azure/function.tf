############################# Storage Account ###########################

resource "azurerm_storage_account" "main" {
  name                     = format("%sstorage%s", var.projectPrefix, random_id.buildSuffix.hex)
  resource_group_name      = azurerm_resource_group.shared.name
  location                 = azurerm_resource_group.shared.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    Name = format("%s-storage-%s", var.resourceOwner, random_id.buildSuffix.hex)
  }
}

############################# Service Plan ###########################

# Create Consumption plan
resource "azurerm_service_plan" "main" {
  name                = format("%s-service-plan-%s", var.projectPrefix, random_id.buildSuffix.hex)
  resource_group_name = azurerm_resource_group.shared.name
  location            = azurerm_resource_group.shared.location
  os_type             = "Windows"
  sku_name            = "Y1"
  tags = {
    Name = format("%s-service-plan-%s", var.resourceOwner, random_id.buildSuffix.hex)
  }
}

############################# Function App ###########################

resource "azurerm_windows_function_app" "main" {
  name                       = format("%s-functionApp-%s", var.projectPrefix, random_id.buildSuffix.hex)
  resource_group_name        = azurerm_resource_group.shared.name
  location                   = azurerm_resource_group.shared.location
  storage_account_name       = azurerm_storage_account.main.name
  storage_account_access_key = azurerm_storage_account.main.primary_access_key
  service_plan_id            = azurerm_service_plan.main.id
  identity {
    type = "SystemAssigned"
  }
  site_config {
    application_stack {
      powershell_core_version = 7.2
    }
  }
  tags = {
    Name = format("%s-functionApp-%s", var.resourceOwner, random_id.buildSuffix.hex)
  }
}

############################# Function PowerShell ###########################

# PowerShell script variable rendering
locals {
  vmssFunction = templatefile("${path.module}/templates/vmssFunction.ps1", {
    vmssNameWest = azurerm_linux_virtual_machine_scale_set.appWest.name
    rgNameWest   = azurerm_resource_group.appWest.name
    vmssNameEast = azurerm_linux_virtual_machine_scale_set.appEast.name
    rgNameEast   = azurerm_resource_group.appEast.name
  })
}

# Create PowerShell function to query VMSS instances
resource "azurerm_function_app_function" "main" {
  name            = format("%s-function-%s", var.projectPrefix, random_id.buildSuffix.hex)
  function_app_id = azurerm_windows_function_app.main.id
  language        = "PowerShell"
  file {
    name    = "vmssFunction.ps1"
    content = local.vmssFunction
  }
  config_json = jsonencode({
    "bindings" = [
      {
        "authLevel" = "function"
        "direction" = "in"
        "methods" = [
          "get",
          "post",
        ]
        "name" = "Request"
        "type" = "httpTrigger"
      },
      {
        "direction" = "out"
        "name"      = "Response"
        "type"      = "http"
      },
    ]
  })
  test_data = jsonencode({
    "vmssName" = "${azurerm_linux_virtual_machine_scale_set.appEast.name}"
    "rgName"   = "${azurerm_resource_group.appEast.name}"
  })
}

############################# Role Assignment ###########################

# Retrieve Subscription info
data "azurerm_subscription" "main" {
}

# Create role assignment
resource "azurerm_role_assignment" "function" {
  scope                = data.azurerm_subscription.main.id
  role_definition_name = "Reader"
  principal_id         = azurerm_windows_function_app.main.identity[0].principal_id
}
