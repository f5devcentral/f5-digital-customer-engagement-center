# Set minimum Terraform version and Terraform Cloud backend
terraform {
  required_version = ">= 0.14.5"
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "0.10"
    }
    azurerm = ">= 2.69"
  }
}
