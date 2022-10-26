output "public_IP_nginx" {
  description = "Public IP address of the NGINX deployment"
  value       = azurerm_public_ip.nginx.ip_address
}
