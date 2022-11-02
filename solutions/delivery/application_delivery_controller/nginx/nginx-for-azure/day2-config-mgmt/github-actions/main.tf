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

############################# GitHub Actions ###########################

# GitHub workflow rendering
locals {
  nginxGithubActions = templatefile("${path.module}/templates/nginxGithubActions.yml", {
    sharedResourceGroup  = var.rgShared
    appWestResourceGroup = var.rgAppWest
    appEastResourceGroup = var.rgAppEast
    vmssNameWest         = var.vmssAppWest
    vmssNameEast         = var.vmssAppEast
    nginxDeploymentName  = var.nginxDeploymentName
  })
}

# GitHub workflow output file
resource "local_file" "nginxGithubActions" {
  content  = local.nginxGithubActions
  filename = "../../${path.module}/nginxGithubActions.yml"
}
