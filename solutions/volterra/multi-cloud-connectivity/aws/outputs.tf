output "bu1JumphostPublicIp" {
  description = "BU1 Jumphost Public IP"
  value       = local.jumphosts["bu1"].create ? module.jumphost["bu1"].workspaceManagementAddress : null
}
output "vpcIdBu1" {
  description = "vpc id"
  value       = module.vpc["bu1"].vpc_id
}
output "vpcIdBu2" {
  description = "vpc id"
  value       = module.vpc["bu2"].vpc_id
}
output "vpcIdBu3" {
  description = "vpc id"
  value       = module.vpc["bu3"].vpc_id
}
