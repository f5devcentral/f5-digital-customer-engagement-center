output "buildSuffix" {
  description = "build suffix for the deployment"
  value       = local.buildSuffix
}
output "volterraVirtualSite" {
  description = "name of virtual site across all clouds"
  value       = volterra_virtual_site.site.name
}
