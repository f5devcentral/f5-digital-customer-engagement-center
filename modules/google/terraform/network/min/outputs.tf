locals {
  vpcs = {
    "main"    = module.mgmt.network_self_link
    "mgmt"    = module.mgmt.network_self_link
    "public"  = module.public.network_self_link
    "private" = module.private.network_self_link
  }
  subnets = {
    "main"    = element(module.mgmt.subnets_self_links, 0)
    "mgmt"    = element(module.mgmt.subnets_self_links, 0)
    "public"  = element(module.public.subnets_self_links, 0)
    "private" = element(module.private.subnets_self_links, 0)
  }
}

output "vpcs" {
  value       = local.vpcs
  description = <<EOD
A map of VPC networks created by module, keyed by usage context.
EOD
}

output "subnets" {
  value       = local.subnets
  description = <<EOD
A map of subnetworks created by module, keyed by usage context.
EOD
}
