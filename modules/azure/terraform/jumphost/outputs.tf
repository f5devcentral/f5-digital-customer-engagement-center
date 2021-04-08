output "publicIp" {
  description = "public ip address of the instance"
  value       = azurerm_public_ip.mgmtPip.ip_address
}

output "jumphostInfo" {
  description = "VM instance output parameters as documented here: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine"
  value       = azurerm_linux_virtual_machine.jumphost
}
