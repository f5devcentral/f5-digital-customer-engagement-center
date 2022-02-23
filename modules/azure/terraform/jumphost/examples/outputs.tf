output "jumphostPublicIp" {
  description = "public ip address of the instance"
  value       = module.jumphost.publicIp
}
output "jumphostInfo" {
  description = "VM instance output parameters as documented here: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine"
  value       = module.jumphost.jumphostInfo
  sensitive   = true
}
