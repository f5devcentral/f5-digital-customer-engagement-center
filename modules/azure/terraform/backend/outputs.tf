output "privateIp" {
  description = "private ip address of the instance"
  value       = azurerm_linux_virtual_machine.backend.private_ip_address
}
output "publicIp" {
  description = "public ip address of the instance"
  value       = var.public_address ? azurerm_public_ip.this.public_address : null
}
output "backendInfo" {
  description = "VM instance output parameters as documented here: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine"
  value       = azurerm_linux_virtual_machine.backend
}
