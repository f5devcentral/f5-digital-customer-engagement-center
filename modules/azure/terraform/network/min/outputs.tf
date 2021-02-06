locals {
  vpcs = {
    "main" = azurerm_virtual_network.main.id
  }
  subnets = {
    "mgmt"    = azurerm_subnet.mgmt.id
    "public"  = azurerm_subnet.ext.id
    "private" = azurerm_subnet.int.id
  }
}

output "vpcs" {
  value = local.vpcs
}

output "subnets" {
  value = local.subnets
}
