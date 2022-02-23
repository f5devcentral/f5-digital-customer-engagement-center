output "web_address_for_application" {
  description = "Public URL to access web app"
  value       = "http://${azurerm_public_ip.public_lb_frontend_ip.ip_address}/"
}
output "ssh_address_for_app_server" {
  description = "SSH to app server"
  value       = "ssh azureuser@${azurerm_public_ip.public_lb_frontend_ip.ip_address}"
}

output "ssh_username_for_app_server" {
  description = "SSH username for app server"
  value       = "azureuser"
}

output "bigip_mgmt_public_ip_addresses" {
  description = "public ip for bigip mgmt console"
  value       = module.bigip.*.mgmtPublicIP
}
output "bigip_mgmt_username" {
  description = "username for bigip mgmt console"
  value       = "quickstart"
}

output "bigip_password" {
  description = "password for bigip mgmt console"
  value       = var.upassword
}