# Vnet
output "azureVnetId" {
  description = "The ID of the Vnet"
  value       = module.network.vnet_id
}

output "azureVnetName" {
  description = "The Name of the Vnet"
  value       = module.network.vnet_name
}

output "azureVnetCidr" {
  description = "The CIDR block of the VNet"
  value       = concat(module.network.*.vnet_address_space, [""])[0]
}

# Subnets
output "azureSubnets" {
  description = "List of IDs of subnets"
  value       = module.network.vnet_subnets
}

# NAT Gateway
output "azureNatId" {
  description = "The ID of the NAT Gateway"
  value       = azurerm_nat_gateway.mgmt_nat.id
}