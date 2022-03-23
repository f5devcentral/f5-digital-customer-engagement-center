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
