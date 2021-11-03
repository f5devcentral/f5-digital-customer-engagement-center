output "azureJumphostPublicIps" {
  description = "Jumphost Public IPs"
  value       = values(module.jumphost)[*]["publicIp"]
}

output "vnetIds" {
  description = "VNet IDs"
  value       = values(module.network)[*]["vnet_id"]
}
