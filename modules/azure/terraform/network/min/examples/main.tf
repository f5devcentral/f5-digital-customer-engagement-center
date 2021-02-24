# Azure Provider
provider "azurerm" {
  features {}
}

# Create Resource Group
resource "azurerm_resource_group" "main" {
  name     = format("%s-rg-%s", var.projectPrefix, var.buildSuffix)
  location = var.azureLocation

  tags = {
    Name      = format("%s-rg-%s", var.resourceOwner, var.buildSuffix)
    Terraform = "true"
  }
}

# Network Module
module "network_min" {
  source             = "../"
  projectPrefix      = var.projectPrefix
  buildSuffix        = var.buildSuffix
  resourceOwner      = var.resourceOwner
  azureResourceGroup = azurerm_resource_group.main.name
  azureLocation      = var.azureLocation
  azureCidr          = var.azureCidr
  azureSubnets       = var.azureSubnets

  depends_on = [azurerm_resource_group.main]
}
