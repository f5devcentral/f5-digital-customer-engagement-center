output "jumphostPublicIp" {
  value = module.jumphost.workspaceManagementAddress
}

output "coderAdminPassword" {
  value = random_password.password.result
}
