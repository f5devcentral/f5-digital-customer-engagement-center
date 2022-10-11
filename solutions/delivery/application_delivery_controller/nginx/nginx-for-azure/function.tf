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

############################# Application Insights ###########################

resource "azurerm_application_insights" "main" {
  name                = format("%s-app-insights-%s", var.projectPrefix, random_id.buildSuffix.hex)
  location            = azurerm_resource_group.shared.location
  resource_group_name = azurerm_resource_group.shared.name
  application_type    = "web"
  tags = {
    Name = format("%s-app-insights-%s", var.resourceOwner, random_id.buildSuffix.hex)
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
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = "${azurerm_application_insights.main.instrumentation_key}",
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = "${azurerm_application_insights.main.connection_string}",
    "WEBSITE_RUN_FROM_PACKAGE"              = "1",
    "AzureWebJobsDisableHomepage"           = "true",
  }
  site_config {
    application_stack {
      powershell_core_version = 7.2
    }
  }
  identity {
    type = "SystemAssigned"
  }
  tags = {
    Name = format("%s-functionApp-%s", var.resourceOwner, random_id.buildSuffix.hex)
  }
}

data "azurerm_function_app_host_keys" "main" {
  name                = azurerm_windows_function_app.main.name
  resource_group_name = azurerm_resource_group.shared.name
}

############################# Function PowerShell ###########################

# PowerShell script variable rendering
locals {
  vmssFunctionPs1 = templatefile("${path.module}/function-app/vmAutoscaleNginxConfig/vmssFunction.ps1", {
    vmssNameWest        = azurerm_linux_virtual_machine_scale_set.appWest.name
    rgNameWest          = azurerm_resource_group.appWest.name
    vmssNameEast        = azurerm_linux_virtual_machine_scale_set.appEast.name
    rgNameEast          = azurerm_resource_group.appEast.name
    rgNameShared        = azurerm_resource_group.shared.name
    nginxDeploymentName = azurerm_resource_group_template_deployment.n4a.name
  })
}

############################# Zip Package Contents ###########################

# Zip function package contents
data "archive_file" "vmssFunction" {
  type = "zip"
  source {
    content  = local.vmssFunctionPs1
    filename = "vmAutoscaleNginxConfig/vmssFunction.ps1"
  }
  source {
    content  = templatefile("${path.module}/function-app/vmAutoscaleNginxConfig/function.json", {})
    filename = "vmAutoscaleNginxConfig/function.json"
  }
  source {
    content  = templatefile("${path.module}/function-app/host.json", {})
    filename = "host.json"
  }
  source {
    content  = templatefile("${path.module}/function-app/profile.ps1", {})
    filename = "profile.ps1"
  }
  source {
    content  = templatefile("${path.module}/function-app/requirements.psd1", {})
    filename = "requirements.psd1"
  }
  output_path = "${path.module}/function-app.zip"
}

############################# Publish Code ###########################

# Locals to help with code readability
locals {
  publish_code_command = "az functionapp deployment source config-zip -g ${azurerm_resource_group.shared.name} --name ${azurerm_windows_function_app.main.name} --src ${data.archive_file.vmssFunction.output_path}"
}

# Upload function package code to Function App
resource "null_resource" "vmssFunction_publish" {
  provisioner "local-exec" {
    command = local.publish_code_command
  }
  triggers = {
    input_json           = filemd5(data.archive_file.vmssFunction.output_path)
    publish_code_command = local.publish_code_command
  }
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
