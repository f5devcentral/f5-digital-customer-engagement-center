locals {
  vpcs = {
    "main" = module.network.vnet_id
  }
  subnets = {
    "mgmt"    = element(module.network.vnet_subnets, 0)
    "public"  = element(module.network.vnet_subnets, 1)
    "private" = element(module.network.vnet_subnets, 2)
  }
}

output "vpcs" {
  value       = local.vpcs
  description = <<EOD
A map of VPC networks created by module, keyed by usage context.
EOD
}

output "subnets" {
  value       = local.subnets
  description = <<EOD
A map of subnetworks created by module, keyed by usage context.
EOD
}

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

output "azureNatId" {
  description = "The ID of the NAT Gateway"
  value       = azurerm_nat_gateway.mgmt_nat.id
}
