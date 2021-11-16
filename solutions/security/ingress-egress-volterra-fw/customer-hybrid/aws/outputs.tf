output "bu1JumphostPublicIp" {
  description = "BU1 Jumphost Public IP"
  value       = module.jumphost["dc1"].workspaceManagementAddress
}
output "vpcId" {
  value       = jsonencode({ for k, v in module.vpc : k => v.vpc_id })
  description = "VPC id's"
}
