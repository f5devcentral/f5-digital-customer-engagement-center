############################ Public IP ############################

resource "azurerm_public_ip" "nginx" {
  name                = format("%s-pip-nginx-%s", var.projectPrefix, random_id.buildSuffix.hex)
  location            = azurerm_resource_group.shared.location
  resource_group_name = azurerm_resource_group.shared.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    Name = format("%s-pip-nginx-%s", var.resourceOwner, random_id.buildSuffix.hex)
  }
}

############################ Managed Identity ############################

resource "azurerm_user_assigned_identity" "nginx" {
  count               = var.userAssignedIdentityId == null ? 1 : 0
  location            = azurerm_resource_group.shared.location
  name                = format("%s-identity-nginx-%s", var.projectPrefix, random_id.buildSuffix.hex)
  resource_group_name = azurerm_resource_group.shared.name
  tags = {
    Name = format("%s-identity-nginx-%s", var.resourceOwner, random_id.buildSuffix.hex)
  }
}

############################ NGINX for Azure Deployment ############################

resource "azurerm_resource_group_template_deployment" "nginx" {
  name                = format("%s-nginx-%s", var.projectPrefix, random_id.buildSuffix.hex)
  resource_group_name = azurerm_resource_group.shared.name
  deployment_mode     = "Incremental"
  parameters_content = jsonencode({
    "nginxDeploymentName"    = { value = format("%s-nginx-%s", var.projectPrefix, random_id.buildSuffix.hex) }
    "location"               = { value = azurerm_resource_group.shared.location }
    "sku"                    = { value = "publicpreview_Monthly_gmz7xq9ge3py" }
    "publicIPName"           = { value = format("%s-pip-nginx-%s", var.projectPrefix, random_id.buildSuffix.hex) }
    "subnetName"             = { value = azurerm_subnet.shared.name }
    "virtualNetworkName"     = { value = azurerm_virtual_network.shared.name }
    "userAssignedIdentityId" = { value = var.userAssignedIdentityId == null ? azurerm_user_assigned_identity.nginx[0].id : var.userAssignedIdentityId }
    "enableMetrics"          = { value = var.enableMetrics }
  })
  template_content = templatefile("${path.module}/templates/nginxDeploy.json", {})
}
