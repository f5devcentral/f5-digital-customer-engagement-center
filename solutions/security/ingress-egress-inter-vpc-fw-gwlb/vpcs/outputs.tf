output "jumphostPublicIp" {
  description = "List of public ip's for the jumphosts"
  value       = module.jumphost[*]
}
output "bigipPublicIp" {
  description = "Public ip for the BIGIP, access on port 8443"
  value       = module.gwlb-bigip.bigipAz1Ip
}
output "bigipPassword" {
  description = "Password for the admin usernmae"
  value       = module.gwlb-bigip.bigipPassword
}
