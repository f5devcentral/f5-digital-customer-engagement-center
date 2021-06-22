output "internetVpcDataJumphostPublicIp" {
  description = "List of public ip's for the jumphosts"
  value       = module.jumphost[*].internetVpcData.workspaceManagementAddress
}

output "spoke10VpcDataJumphostPublicIp" {
  description = "List of public ip's for the jumphosts"
  value       = module.jumphost[*].spoke10VpcData.workspaceManagementAddress
}

output "spoke20VpcDataJumphostPublicIp" {
  description = "List of public ip's for the jumphosts"
  value       = module.jumphost[*].spoke20VpcData.workspaceManagementAddress
}

output "bigipPublicIp" {
  description = "Public ip for the BIGIP, access on port 8443"
  value       = module.gwlb-bigip.bigipIp
}
output "bigipPassword" {
  description = "Password for the admin usernmae"
  value       = module.gwlb-bigip.bigipPassword
}
