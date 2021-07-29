output "bu11JumphostPublicIp" {
  description = "BU11 Jumphost Public IP"
  value       = module.jumphost["bu11"].publicIp
}
output "bu12JumphostPublicIp" {
  description = "BU12 Jumphost Public IP"
  value       = module.jumphost["bu12"].publicIp
}
output "bu13JumphostPublicIp" {
  description = "BU13 Jumphost Public IP"
  value       = module.jumphost["bu13"].publicIp
}
output "transitBu11JumphostPublicIp" {
  description = "Transit BU11 Jumphost Public IP"
  value       = module.jumphost["transitBu11"].publicIp
}
output "transitBu12JumphostPublicIp" {
  description = "Transit BU12 Jumphost Public IP"
  value       = module.jumphost["transitBu12"].publicIp
}
output "transitBu13JumphostPublicIp" {
  description = "Transit BU13 Jumphost Public IP"
  value       = module.jumphost["transitBu13"].publicIp
}
output "transitHubJumphostPublicIp" {
  description = "Transit Hub Jumphost Public IP"
  value       = module.jumphost["transitHub"].publicIp
}
output "transitBu11JumphostPrivateIp" {
  description = "Transit BU11 Jumphost Private IP"
  value       = module.jumphost["transitBu11"].jumphostInfo.private_ip_address
}
output "transitBu12JumphostPrivateIp" {
  description = "Transit BU12 Jumphost Private IP"
  value       = module.jumphost["transitBu12"].jumphostInfo.private_ip_address
}
output "transitBu13JumphostPrivateIp" {
  description = "Transit BU13 Jumphost Private IP"
  value       = module.jumphost["transitBu13"].jumphostInfo.private_ip_address
}
output "transitHubJumphostPrivateIp" {
  description = "Transit Hub Jumphost Private IP"
  value       = module.jumphost["transitHub"].jumphostInfo.private_ip_address
}
output "bu11WebServerIP" {
  description = "BU11 Web Server Private IP"
  value       = module.webserver["bu11"].privateIp
}
output "bu12WebServerIP" {
  description = "BU12 Web Server Private IP"
  value       = module.webserver["bu12"].privateIp
}
output "bu13WebServerIP" {
  description = "BU13 Web Server Private IP"
  value       = module.webserver["bu13"].privateIp
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
