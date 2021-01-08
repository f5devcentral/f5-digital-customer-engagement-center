locals {
  vpcs = {
    "main" = azurerm_virtual_network.main
    "mgmt" = azurerm_virtual_network.main
  }
  subnets = {
    "mgmt"    = azurerm_subnet.mgmt
    "public"  = ""
    "private" = ""
  }
}

output "vpcs" {
  value = local.vpcs
}

output "subnets" {
  value = local.subnets
}
