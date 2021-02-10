# Set minimum Terraform version and Terraform Cloud backend
terraform {
  required_version = "~> 0.14"
  required_providers {
    azurerm = "~> 2"
  }
}

# Create a random id
resource "random_id" "id" {
  byte_length = 2
}

# Create locals for module
locals {
  subnetPrefixes = {
    management = cidrsubnet(var.azureVnet.cidr, 8, var.offsets.management)
    external   = cidrsubnet(var.azureVnet.cidr, 8, var.offsets.external)
    internal   = cidrsubnet(var.azureVnet.cidr, 8, var.offsets.internal)
  }
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = var.azureResourceGroup
  vnet_name           = format("%s-vnet-%s", var.context.resourceOwner, var.context.random)
  address_space       = var.azureVnet.cidr
  subnet_prefixes     = [local.subnetPrefixes.management, local.subnetPrefixes.external, local.subnetPrefixes.internal]
  subnet_names        = ["management", "external", "internal"]

  tags = {
    Name      = format("%s-vnet-%s", var.context.resourceOwner, var.context.random)
    Terraform = "true"
  }
}