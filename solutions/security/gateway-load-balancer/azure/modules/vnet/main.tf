resource "azurerm_virtual_network" "vnet" {
  name                = "${var.resource_group_name}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.network_cidr]

  subnet {
    name           = "mgmt"
    address_prefix = var.mgmt_subnet_prefix
  }

  subnet {
    name           = "external"
    address_prefix = var.external_subnet_prefix
  }

  subnet {
    name           = "internal"
    address_prefix = var.internal_subnet_prefix
#    security_group = azurerm_network_security_group.example.id
  }
}