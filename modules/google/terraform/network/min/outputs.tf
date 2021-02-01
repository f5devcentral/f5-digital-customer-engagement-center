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
    "mgmt"    = lookup(module.mgmt.subnets, format("%s/mgmt-subnet-%s", var.gcpRegion, var.buildSuffix), {})
    "public"  = lookup(module.ext.subnets, format("%s/external-subnet-%s", var.gcpRegion, var.buildSuffix), {})
    "private" = lookup(module.int.subnets, format("%s/internal-subnet-%s", var.gcpRegion, var.buildSuffix), {})
  }
}

output "vpcs" {
  value = local.vpcs
}

output "subnets" {
  value = local.subnets
}
