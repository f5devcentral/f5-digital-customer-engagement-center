output "backendPrivateIp" {
  description = "private ip address of the instance"
  value       = module.backend.privateIp
}
output "backendPublicIp" {
  description = "public ip address of the instance"
  value       = module.backend.publicIp
}
output "backendInfo" {
  description = "VM instance output parameters as documented here: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine"
  value       = module.backend.backendInfo
}
