# TODO: @memes - why was the module output full resource definitions? Self-link
# should be sufficient
locals {
  vpcs = {
    "main"    = module.mgmt.network
    "mgmt"    = module.mgmt.network
    "public"  = module.ext.network
    "private" = module.int.network
  }
  subnets = {
    "mgmt"    = element(values(module.mgmt.subnets), 0)
    "public"  = element(values(module.ext.subnets), 0)
    "private" = element(values(module.int.subnets), 0)
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
