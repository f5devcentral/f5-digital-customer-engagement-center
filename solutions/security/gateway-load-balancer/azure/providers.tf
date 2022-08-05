
provider "azurerm" {
  features {}
}

terraform {
  required_version = ">= 1.1.0"
  required_providers {
    azurerm = ">= 3"
  }
}
