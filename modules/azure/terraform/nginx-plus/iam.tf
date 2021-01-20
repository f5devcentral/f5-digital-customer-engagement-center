resource "azurerm_user_assigned_identity" "nginx-sa" {
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location

  name = "nginx-sa-${var.buildSuffix}"
}
