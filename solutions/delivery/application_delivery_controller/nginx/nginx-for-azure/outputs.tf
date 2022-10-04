output "vnetIds" {
  description = "VNet IDs"
  value       = values(module.network)[*]["vnet_id"]
}
output "sharedSubnetIds" {
  description = "Shared Services Subnet IDs"
  value       = module.network["appWest"].vnet_subnets
}
output "appWestIds" {
  description = "appWest Spoke Subnet IDs"
  value       = module.network["appWest"].vnet_subnets
}
output "appEastIds" {
  description = "appEast Spoke Subnet IDs"
  value       = module.network["appEast"].vnet_subnets
}
