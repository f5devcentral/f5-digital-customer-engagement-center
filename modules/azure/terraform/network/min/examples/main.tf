# Azure Provider
provider "azurerm" {
  features {}
}

# Create Resource Group
resource "azurerm_resource_group" "main" {
  name     = format("%s-rg-%s", var.context.resourceOwner, var.context.random)
  location = var.azureVnet.azureLocation
}

# Network Module
module "network" {
  source              = "../"
  azureVnet           = var.azureVnet
  context             = var.context
  azureResourceGroup  = azurerm_resource_group.main.name

  depends_on = [azurerm_resource_group.main]
}
