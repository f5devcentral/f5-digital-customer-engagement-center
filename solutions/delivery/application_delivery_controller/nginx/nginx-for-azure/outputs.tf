output "buildSuffix" {
  description = "Build suffix for resources"
  value       = random_id.buildSuffix.hex
}
output "nginxPublicIp" {
  description = "Public IP address of the NGINX deployment"
  value       = azurerm_public_ip.nginx.ip_address
}
output "nginxDeploymentName" {
  description = "Name of the NGINX deployment"
  value       = format("%s-nginx-%s", var.projectPrefix, random_id.buildSuffix.hex)
}
output "rgShared" {
  description = "Name of the Shared Resource Group"
  value       = azurerm_resource_group.shared.name
}
output "rgAppWest" {
  description = "Name of the App West Resource Group"
  value       = azurerm_resource_group.appWest.name
}
output "rgAppEast" {
  description = "Name of the App East Resource Group"
  value       = azurerm_resource_group.appEast.name
}
output "regionShared" {
  description = "Region where Shared resources are deployed"
  value       = azurerm_resource_group.shared.location
}
output "vmssAppWest" {
  description = "Name of App West VMSS"
  value       = azurerm_linux_virtual_machine_scale_set.appWest.name
}
output "vmssAppEast" {
  description = "Name of App East VMSS"
  value       = azurerm_linux_virtual_machine_scale_set.appEast.name
}
output "autoscaleSettingsAppWest" {
  description = "ID of App West autoscale settings"
  value       = azurerm_monitor_autoscale_setting.appWest.id
}
output "autoscaleSettingsAppEast" {
  description = "ID of App East autoscale settings"
  value       = azurerm_monitor_autoscale_setting.appEast.id
}
