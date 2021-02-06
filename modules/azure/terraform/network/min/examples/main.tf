# Azure Provider
provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-rg-${random_id.buildSuffix.hex}"
  location = var.location
}

# Network Module
module "azure_network" {
  source         = "../"
  prefix         = var.prefix
  buildSuffix    = random_id.buildSuffix.hex
  region         = var.region
  location       = var.location
  resource_group = azurerm_resource_group.main.name
}
