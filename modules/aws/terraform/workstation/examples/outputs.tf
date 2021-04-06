output "jumphostPublicIp" {
  value = module.jumphost.workspaceManagementAddress
}
output "workstation" {
  value = module.jumphost.workstation
}
