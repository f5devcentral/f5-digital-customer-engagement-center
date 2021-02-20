# Set minimum Terraform version and Terraform Cloud backend
terraform {
  required_version = "~> 0.14"
  required_providers {
    azurerm = "~> 2"
  }
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = var.azureResourceGroup
  vnet_name           = format("%s-vnet-%s", var.projectPrefix, var.buildSuffix)
  address_space       = var.azureCidr
  subnet_prefixes     = [var.azureSubnets.management, var.azureSubnets.external, var.azureSubnets.internal]
  subnet_names        = ["management", "external", "internal"]

  tags = {
    Name      = format("%s-vnet-%s", var.resourceOwner, var.buildSuffix)
    Terraform = "true"
  }
}