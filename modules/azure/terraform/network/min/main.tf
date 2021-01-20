#network
# Create a Virtual Network within the Resource Group
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network-${var.buildSuffix}"
  address_space       = [var.cidr]
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
}

# Create the Management Subnet within the Virtual Network
resource "azurerm_subnet" "mgmt" {
  name                 = "${var.prefix}-mgmt-${var.buildSuffix}"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name  = var.resource_group.name
  address_prefix       = var.subnets["subnet1"]
}
