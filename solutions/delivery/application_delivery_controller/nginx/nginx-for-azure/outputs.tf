output "public_IP_n4a" {
  description = "Public IP address of the N4A deployment"
  value       = azurerm_public_ip.n4a.ip_address
}
