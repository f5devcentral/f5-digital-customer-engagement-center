# Create three VPC networks in project for use with multi-leg deployments

terraform {
  required_version = "~> 0.14.5"
  required_providers {
    google = "~> 3.54"
  }
}

module "mgmt" {
  source                                 = "terraform-google-modules/network/google"
  version                                = "3.0.1"
  project_id                             = var.gcpProjectId
  network_name                           = format("%s-mgmt-network-%s", var.projectPrefix, var.buildSuffix)
  description                            = "Management VPC"
  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = false
  mtu                                    = 1460
  routing_mode                           = "REGIONAL"
  subnets = [
    {
      subnet_name                            = format("%s-mgmt-subnet-%s", var.projectPrefix, var.buildSuffix)
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
  network_name = format("%s-internal-network-%s", var.projectPrefix, var.buildSuffix)

  description                            = "Internal VPC"
  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = false
  mtu                                    = 1460
  routing_mode                           = "REGIONAL"
  subnets = [
    {
      subnet_name                            = format("%s-internal-subnet-%s", var.projectPrefix, var.buildSuffix)
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
      subnet_name                            = format("%s-external-subnet-%s", var.projectPrefix, var.buildSuffix)
      subnet_ip                              = "10.0.30.0/24"
      subnet_region                          = var.gcpRegion
      delete_default_internet_gateway_routes = false
      subnet_private_access                  = false
    }
  ]
}

module "nat" {
  source                             = "terraform-google-modules/cloud-nat/google"
  version                            = "1.3.0"
  project_id                         = var.gcpProjectId
  region                             = var.gcpRegion
  name                               = format("%s-mgmt-router-nat-%s", var.projectPrefix, var.buildSuffix)
  router                             = format("%s-mgmt-router-%s", var.projectPrefix, var.buildSuffix)
  create_router                      = true
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  network                            = module.mgmt.network_self_link
  subnetworks = [
    {
      name                     = element(module.mgmt.subnets_self_links, 0)
      source_ip_ranges_to_nat  = ["ALL_IP_RANGES"]
      secondary_ip_range_names = []
    },
  ]
}
