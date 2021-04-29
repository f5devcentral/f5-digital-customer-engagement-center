# Create VPC networks and subnets from VPC options

locals {
  # Map 'main' to mgmt, private, or public VPC in that order of preference
  aka_main = element([for vpc in ["mgmt", "private", "public"] : vpc if var.vpc_options[vpc] != null], 0)
  # Create a simple map of VPC archetype to full self-link
  vpcs    = { for vpc in module.vpc : element(regex("-(mgmt|private|public)-", vpc.network_name), 0) => vpc.network_self_link }
  subnets = { for vpc in module.vpc : element(regex("-(mgmt|private|public)-", vpc.network_name), 0) => element(vpc.subnets_self_links, 0) }
}

# Create a VPC network and associated regional subnet for each non-null entry in
# vpc_options.
module "vpc" {
  for_each                               = { for k, v in var.vpc_options : k => v if v != null }
  source                                 = "terraform-google-modules/network/google"
  version                                = "3.0.1"
  project_id                             = var.gcpProjectId
  network_name                           = format("%s-%s-vpc-%s", var.projectPrefix, each.key, var.buildSuffix)
  description                            = format("%s VPC (%s-%s)", each.key, var.projectPrefix, var.buildSuffix)
  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = var.features.isolated
  mtu                                    = each.value.mtu
  routing_mode                           = "REGIONAL"
  subnets = [
    {
      subnet_name           = format("%s-%s-subnet-%s", var.projectPrefix, each.key, var.buildSuffix)
      subnet_ip             = each.value.primary_cidr
      subnet_region         = var.gcpRegion
      subnet_private_access = var.features.isolated
    }
  ]
  routes = var.features.isolated ? [
    {
      name              = format("%s-%s-restricted-api-%s", var.projectPrefix, each.key, var.buildSuffix)
      description       = format("Restricted Google API route (%s-%s)", var.projectPrefix, var.buildSuffix)
      destination_range = "199.36.153.4/30"
      next_hop_internet = true
    }
  ] : []
}

# BIG-IP on-boarding, jumphost/workstation software, etc. usually needs to be
# sourced from public sites. This NAT will allow VMs without a public IP to reach
# the internet from the control-plane VPC.
# Note: isolated feature flag overrides any per-vpc NAT flag
module "nat" {
  source   = "terraform-google-modules/cloud-router/google"
  version  = "0.4.0"
  for_each = { for k, v in var.vpc_options : k => v if v != null && lookup(coalesce(v, {}), "nat", false) && !var.features.isolated }
  project  = var.gcpProjectId
  region   = var.gcpRegion
  name     = format("%s-%s-router-%s", var.projectPrefix, each.key, var.buildSuffix)
  network  = local.vpcs[each.key]
  nats = [{
    name = format("%s-%s-nat-%s", var.projectPrefix, each.key, var.buildSuffix)
  }]

  depends_on = [module.vpc]
}
