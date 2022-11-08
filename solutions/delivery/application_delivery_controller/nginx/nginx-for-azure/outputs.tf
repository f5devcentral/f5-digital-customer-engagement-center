output "nginxPublicIp" {
  description = "Public IP address of the NGINX deployment"
  value       = azurerm_public_ip.nginx.ip_address
}
output "nginxDeploymentName" {
  description = "Name of the NGINX deployment"
  value       = format("%s-nginx-%s", var.projectPrefix, random_id.buildSuffix.hex)
}
