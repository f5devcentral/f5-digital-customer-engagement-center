# Set minimum Terraform version and Terraform Cloud backend
terraform {
  required_version = "~> 0.14"
  required_providers {
    azurerm = "~> 2"
  }
}

# Create Network and subnets
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

# Retreive management subnet info
data "azurerm_subnet" "mgmt" {
  name                 = "management"
  virtual_network_name = module.network.vnet_name
  resource_group_name  = var.azureResourceGroup
}

# Create NAT gateway
resource "azurerm_public_ip" "mgmt_nat" {
  name                = format("%s-mgmt-nat-pip-%s", var.projectPrefix, var.buildSuffix)
  resource_group_name = var.azureResourceGroup
  location            = var.azureLocation
  sku                 = "Standard"
  allocation_method   = "Static"

  tags = {
    Name      = format("%s-mgmt-nat-pip-%s", var.resourceOwner, var.buildSuffix)
    Terraform = "true"
  }
}

resource "azurerm_nat_gateway" "mgmt_nat" {
  name                = format("%s-mgmt-nat-%s", var.projectPrefix, var.buildSuffix)
  resource_group_name = var.azureResourceGroup
  location            = var.azureLocation
  sku_name            = "Standard"

  tags = {
    Name      = format("%s-mgmt-nat-%s", var.resourceOwner, var.buildSuffix)
    Terraform = "true"
  }
}

resource "azurerm_nat_gateway_public_ip_association" "mgmt_nat" {
  nat_gateway_id       = azurerm_nat_gateway.mgmt_nat.id
  public_ip_address_id = azurerm_public_ip.mgmt_nat.id
}

resource "azurerm_subnet_nat_gateway_association" "mgmt_nat" {
  subnet_id      = data.azurerm_subnet.mgmt.id
  nat_gateway_id = azurerm_nat_gateway.mgmt_nat.id
}