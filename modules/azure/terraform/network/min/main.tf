terraform {
  required_version = "~> 0.14"
  required_providers {
    azurerm = "~> 2"
  }
}

# Network
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network-${var.buildSuffix}"
  address_space       = [var.cidr]
  resource_group_name = var.resource_group
  location            = var.location
}

# Subnets
# Management Subnet
resource "azurerm_subnet" "mgmt" {
  name                 = "${var.prefix}-mgmt-${var.buildSuffix}"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name  = var.resource_group
  address_prefixes     = [var.subnets["subnet1"]]
}

# External Subnet
resource "azurerm_subnet" "ext" {
  name                 = "${var.prefix}-ext-${var.buildSuffix}"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name  = var.resource_group
  address_prefixes     = [var.subnets["subnet2"]]
}

# Internal Subnet
resource "azurerm_subnet" "int" {
  name                 = "${var.prefix}-int-${var.buildSuffix}"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name  = var.resource_group
  address_prefixes     = [var.subnets["subnet3"]]
}
