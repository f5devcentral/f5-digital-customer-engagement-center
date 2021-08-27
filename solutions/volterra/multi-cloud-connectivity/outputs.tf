output "buildSuffix" {
  description = "build suffix for the deployment"
  value       = random_id.build_suffix.hex
}
output "volterraVirtualSite" {
  description = "name of virtual site across all clouds"
  value       = volterra_virtual_site.site.name
}
