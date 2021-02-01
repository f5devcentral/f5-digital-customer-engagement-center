# vpc

terraform {
  required_version = "> 0.12"
  required_providers {
    google = "~> 3.54"
  }
}

module "mgmt" {
  source                                 = "terraform-google-modules/network/google"
  version                                = "3.0.1"
  project_id                             = var.gcpProjectId
  network_name                           = format("mgmt-network-%s", var.buildSuffix)
  description                            = "Management VPC"
  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = false
  mtu                                    = 1460
  routing_mode                           = "REGIONAL"
  subnets = [
    {
      subnet_name                            = format("mgmt-subnet-%s", var.buildSuffix)
      subnet_ip                              = "10.0.10.0/24"
      subnet_region                          = var.gcpRegion
      delete_default_internet_gateway_routes = false
      subnet_private_access                  = false
    }
  ]
}

module "int" {
  source       = "terraform-google-modules/network/google"
  version      = "3.0.1"
  project_id   = var.gcpProjectId
  network_name = format("internal-network-%s", var.buildSuffix)

  description                            = "Internal VPC"
  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = false
  mtu                                    = 1460
  routing_mode                           = "REGIONAL"
  subnets = [
    {
      subnet_name                            = format("internal-subnet-%s", var.buildSuffix)
      subnet_ip                              = "10.0.20.0/24"
      subnet_region                          = var.gcpRegion
      delete_default_internet_gateway_routes = false
      subnet_private_access                  = false
    }
  ]
}

module "ext" {
  source       = "terraform-google-modules/network/google"
  version      = "3.0.1"
  project_id   = var.gcpProjectId
  network_name = format("external-network-%s", var.buildSuffix)

  description                            = "External VPC"
  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = false
  mtu                                    = 1460
  routing_mode                           = "REGIONAL"
  subnets = [
    {
      subnet_name                            = format("external-subnet-%s", var.buildSuffix)
      subnet_ip                              = "10.0.30.0/24"
      subnet_region                          = var.gcpRegion
      delete_default_internet_gateway_routes = false
      subnet_private_access                  = false
    }
  ]
}

# TODO: @memes - why NAT on internal? Software installation? Review.
# TODO: @memes - multi-nic BIG-IP often needs NAT on management to install software
module "int-nat" {
  source                             = "terraform-google-modules/cloud-nat/google"
  version                            = "1.3.0"
  project_id                         = var.gcpProjectId
  region                             = var.gcpRegion
  name                               = format("%s-int-router-nat", var.buildSuffix)
  router                             = format("%s-int-router", var.buildSuffix)
  create_router                      = true
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  network                            = module.int.network_self_link
  subnetworks = [
    {
      name                     = element(module.int.subnets_self_links, 0)
      source_ip_ranges_to_nat  = ["ALL_IP_RANGES"]
      secondary_ip_range_names = []
    },
  ]
}
