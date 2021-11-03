output "webServerPrivateIp" {
  description = "private ip address of the instance"
  value       = module.webServer.privateIp
}
output "webServerInfo" {
  description = "VM instance output parameters as documented here: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine"
  value       = module.webServer.webServerInfo
  sensitive   = true

}
