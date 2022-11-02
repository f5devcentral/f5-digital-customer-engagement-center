############################# Provider ###########################

provider "azurerm" {
  features {}
}

# Set Terraform and provider versions
terraform {
  required_version = ">= 1.2.0"
  required_providers {
    azurerm = ">= 3"
  }
}

############################# Storage Account ###########################

resource "azurerm_storage_account" "main" {
  name                     = format("%sstorage%s", var.projectPrefix, var.buildSuffix)
  resource_group_name      = var.rgShared
  location                 = var.regionShared
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    Name = format("%s-storage-%s", var.resourceOwner, var.buildSuffix)
  }
}

############################# Application Insights ###########################

resource "azurerm_application_insights" "main" {
  name                = format("%s-app-insights-%s", var.projectPrefix, var.buildSuffix)
  location            = var.regionShared
  resource_group_name = var.rgShared
  application_type    = "web"
  tags = {
    Name = format("%s-app-insights-%s", var.resourceOwner, var.buildSuffix)
  }
}

############################# Service Plan ###########################

# Create Consumption plan
resource "azurerm_service_plan" "main" {
  name                = format("%s-service-plan-%s", var.projectPrefix, var.buildSuffix)
  resource_group_name = var.rgShared
  location            = var.regionShared
  os_type             = "Windows"
  sku_name            = "Y1"
  tags = {
    Name = format("%s-service-plan-%s", var.resourceOwner, var.buildSuffix)
  }
}

############################# Function App ###########################

resource "azurerm_windows_function_app" "main" {
  name                       = format("%s-functionApp-%s", var.projectPrefix, var.buildSuffix)
  resource_group_name        = var.rgShared
  location                   = var.regionShared
  storage_account_name       = azurerm_storage_account.main.name
  storage_account_access_key = azurerm_storage_account.main.primary_access_key
  service_plan_id            = azurerm_service_plan.main.id
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"    = "1",
    "AzureWebJobsDisableHomepage" = "true",
  }
  site_config {
    application_insights_connection_string = azurerm_application_insights.main.connection_string
    application_insights_key               = azurerm_application_insights.main.instrumentation_key
    application_stack {
      powershell_core_version = 7.2
    }
  }
  identity {
    type = "SystemAssigned"
  }
  tags = {
    Name = format("%s-functionApp-%s", var.resourceOwner, var.buildSuffix)
  }
}

############################# Role Assignment ###########################

# Retrieve Subscription info
data "azurerm_subscription" "main" {
}

# Create role assignment
resource "azurerm_role_assignment" "function" {
  scope                = data.azurerm_subscription.main.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_windows_function_app.main.identity[0].principal_id
}

############################# Function PowerShell ###########################

# PowerShell script variable rendering
locals {
  vmssFunctionPs1 = templatefile("${path.module}/function-app/vmAutoscaleNginxConfig/vmssFunction.ps1", {
    vmssAppWest         = var.vmssAppWest
    rgWest              = var.rgAppWest
    vmssAppEast         = var.vmssAppEast
    rgEast              = var.rgAppEast
    rgShared            = var.rgShared
    nginxDeploymentName = var.nginxDeploymentName
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
  publish_code_command = "az functionapp deployment source config-zip -g ${var.rgShared} --name ${azurerm_windows_function_app.main.name} --src ${data.archive_file.vmssFunction.output_path}"
  function_url         = "https://${azurerm_windows_function_app.main.default_hostname}/api/vmAutoscaleNginxConfig?code=${data.azurerm_function_app_host_keys.main.default_function_key}"
}

# Upload function package code to Function App
resource "null_resource" "vmssFunction_publish" {
  provisioner "local-exec" {
    command = local.publish_code_command
  }
  triggers = {
    input_json      = filemd5("${path.module}/function-app/vmAutoscaleNginxConfig/vmssFunction.ps1")
    archive_file_id = data.archive_file.vmssFunction.id
  }
}

# Retrieve Function App keys
data "azurerm_function_app_host_keys" "main" {
  name                = azurerm_windows_function_app.main.name
  resource_group_name = var.rgShared
  depends_on = [
    null_resource.vmssFunction_publish
  ]
}

# Trigger function by calling URL
resource "null_resource" "trigger_function" {
  provisioner "local-exec" {
    command = "curl -s ${local.function_url}"
  }
  triggers = {
    function_publish_id = null_resource.vmssFunction_publish.id
  }
}

############################# Autoscale Notify Settings ###########################

# Initialize notifications for VMSS App West
resource "null_resource" "notifyVmssAppWest" {
  provisioner "local-exec" {
    command = "az monitor autoscale update --ids ${var.autoscaleSettingsAppWest} --add notifications '{\"webhooks\":[]}' --query 'notifications'"
  }
}

# Initialize notifications for VMSS App East
resource "null_resource" "notifyVmssAppEast" {
  provisioner "local-exec" {
    command = "az monitor autoscale update --ids ${var.autoscaleSettingsAppEast} --add notifications '{\"webhooks\":[]}' --query 'notifications'"
  }
}

# Add webhook action for VMSS App West
resource "null_resource" "webhookVmssAppWest" {
  provisioner "local-exec" {
    command = "az monitor autoscale update --ids ${var.autoscaleSettingsAppWest} --add-action webhook ${local.function_url} --query 'notifications'"
  }
  triggers = {
    notify_id           = null_resource.notifyVmssAppWest.id
    function_publish_id = null_resource.vmssFunction_publish.id
  }
}

# Add webhook action for VMSS App East
resource "null_resource" "webhookVmssAppEast" {
  provisioner "local-exec" {
    command = "az monitor autoscale update --ids ${var.autoscaleSettingsAppEast} --add-action webhook ${local.function_url} --query 'notifications'"
  }
  triggers = {
    notify_id           = null_resource.notifyVmssAppEast.id
    function_publish_id = null_resource.vmssFunction_publish.id
  }
}
