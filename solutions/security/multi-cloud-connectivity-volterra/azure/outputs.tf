output "bu11JumphostPublicIp" {
  description = "BU11 Jumphost Public IP"
  value       = local.jumphosts["bu11"].create ? module.jumphost["bu11"].publicIp : null
}
output "bu12JumphostPublicIp" {
  description = "BU12 Jumphost Public IP"
  value       = local.jumphosts["bu12"].create ? module.jumphost["bu12"].publicIp : null
}
output "bu13JumphostPublicIp" {
  description = "BU13 Jumphost Public IP"
  value       = local.jumphosts["bu13"].create ? module.jumphost["bu13"].publicIp : null
}
output "bu11JumphostPrivateIp" {
  description = "BU11 Jumphost Private IP"
  value       = local.jumphosts["bu11"].create ? module.jumphost["bu11"].jumphostInfo.private_ip_address : null
}
output "bu12JumphostPrivateIp" {
  description = "BU12 Jumphost Private IP"
  value       = local.jumphosts["bu12"].create ? module.jumphost["bu12"].jumphostInfo.private_ip_address : null
}
output "bu13JumphostPrivateIp" {
  description = "BU13 Jumphost Private IP"
  value       = local.jumphosts["bu13"].create ? module.jumphost["bu13"].jumphostInfo.private_ip_address : null
}
output "vnetIdBu11" {
  description = "BU11 VNet ID"
  value       = module.network["bu11"].vnet_id
}
output "vnetIdBu12" {
  description = "BU12 VNet ID"
  value       = module.network["bu12"].vnet_id
}
output "vnetIdBu13" {
  description = "BU13 VNet ID"
  value       = module.network["bu13"].vnet_id
}
