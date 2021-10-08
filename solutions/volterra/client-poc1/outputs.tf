output "JumphostPublicIpBu1" {
  description = "BU1 Jumphost Public IP"
  value       = module.jumphost["bu1"].workspaceManagementAddress
}
output "backendPrivateIpBu1" {
  description = "BU1 Backend Private IP"
  value       = module.webserver["bu10"].workspaceManagementAddress
}
output "backendPrivateIpBu2" {
  description = "BU2 Backend Private IP"
  value       = module.webserver["bu20"].workspaceManagementAddress
}
output "backendPrivateIps" {
  description = "Backend Private IPs"
  value       = values(module.webserver)[*]["workspaceManagementAddress"]
}
output "volterraInsideIp" {
  description = "Volterra Site Local Inside IP address"
  value       = data.aws_network_interface.volterra_sli.private_ip
}
output "testURL" {
  description = "URL to test from jumphost client"
  value       = "http://${data.aws_network_interface.volterra_sli.private_ip} -H 'Host: app.shared.acme.com'"
}
