# TODO: @memes - why was the module output full resource definitions? Self-link
# should be sufficient
locals {
  vpcs = {
    "main"   = module.ext.network.network
    "public" = module.ext.network.network
  }
  subnets = {
    "public" = lookup(module.ext.subnets, format("%s/%s-external-subnet-%s", var.gcpRegion, var.projectPrefix, var.buildSuffix), {})
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
