output "jumphostPublicIp" {
  description = "List of public ip's for the jumphosts"
  value       = module.jumphost[*]
}
output "webserversPublicIp" {
  description = "List of ip's for the webservers"
  value       = module.webserver[*]
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
