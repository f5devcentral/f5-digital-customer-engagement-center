output "vpcBu1JumphostPublicIp" {
  value = module.jumphost[*].vpcBu1Jumphost.workstation.public_ip
}
output "vpcBu2JumphostPublicIp" {
  value = module.jumphost[*].vpcBu2Jumphost.workstation.public_ip
}
output "vpcAcmeJumphostPublicIp" {
  value = module.jumphost[*].vpcAcmeJumphost.workstation.public_ip
}
output "vpcBu1WebServerIP" {
  value = module.webserver[*].vpcBu1App1.workstation.private_ip
}
output "vpcBu2WebServerIP" {
  value = module.webserver[*].vpcBu2App1.workstation.private_ip
}
output "vpcAcmeWebServerIP" {
  value = module.webserver[*].vpcAcmeApp1.workstation.private_ip
}
output "vpcIdAcme" {
  description = "vpc id"
  value       = module.vpcAcme.vpc_id
}
output "vpcIdBu1" {
  description = "vpc id"
  value       = module.vpcBu1.vpc_id
}
output "vpcIdBu2" {
  description = "vpc id"
  value       = module.vpcBu2.vpc_id
}

#output "vpcIdTransitAcme" {
#  description = "vpc id"
#  value       = module.vpcTransitAcme.vpc_id
#}
#output "vpcIdTransitBu1" {
#  description = "vpc id"
#  value       = module.vpcTransitBu1.vpc_id
#}
#output "vpcIdTransitBu2" {
#  description = "vpc id"
#  value       = module.vpcTransitBu2.vpc_id
#}
#output "bigipPublicIp" {
#  description = "Public ip for the BIGIP, access on port 8443"
#  value       = module.gwlb-bigip.bigipAz1Ip
#}
#output "bigipPassword" {
#  description = "Password for the admin usernmae"
#  value       = module.gwlb-bigip.bigipPassword
#}
