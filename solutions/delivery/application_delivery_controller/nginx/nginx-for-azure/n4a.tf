############################ N4A Deployment ############################

resource "azurerm_public_ip" "n4a" {
  name                = format("%s-pip-n4a-%s", var.projectPrefix, random_id.buildSuffix.hex)
  location            = azurerm_resource_group.shared.location
  resource_group_name = azurerm_resource_group.shared.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    Name = format("%s-pip-n4a-%s", var.resourceOwner, random_id.buildSuffix.hex)
  }
}

############################ N4A Deployment ############################

resource "azurerm_resource_group_template_deployment" "n4a" {
  name                = format("%s-n4a-%s", var.projectPrefix, random_id.buildSuffix.hex)
  resource_group_name = azurerm_resource_group.shared.name
  deployment_mode     = "Incremental"
  parameters_content = jsonencode({
    "nginxDeploymentName" = { value = format("%s-n4a-%s", var.projectPrefix, random_id.buildSuffix.hex) }
    "location"            = { value = azurerm_resource_group.shared.location }
    "sku"                 = { value = "publicpreview_Monthly_gmz7xq9ge3py" }
    "publicIPName"        = { value = format("%s-pip-n4a-%s", var.projectPrefix, random_id.buildSuffix.hex) }
    "subnetName"          = { value = azurerm_subnet.shared.name }
    "virtualNetworkName"  = { value = azurerm_virtual_network.shared.name }
    "rootConfigFilePath"  = { value = "/etc/nginx/nginx.conf" }
    "rootConfigContent"   = { value = base64encode(templatefile("${path.module}/templates/nginx.conf", {})) }
  })
  template_content = templatefile("${path.module}/templates/n4aDeploy.json", {})
}
