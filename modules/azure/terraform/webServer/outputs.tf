output "privateIp" {
  description = "private ip address of the instance"
  value       = azurerm_linux_virtual_machine.webServer.private_ip_address
}

output "webServerInfo" {
  description = "VM instance output parameters as documented here: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine"
  value       = azurerm_linux_virtual_machine.webServer
}
