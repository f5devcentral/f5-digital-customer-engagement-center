# vpc

terraform {
  required_version = "~> 0.14.5"
  required_providers {
    google = "~> 3.54"
  }
}

module "ext" {
  source       = "terraform-google-modules/network/google"
  version      = "3.0.1"
  project_id   = var.gcpProjectId
  network_name = format("%s-external-network-%s", var.projectPrefix, var.buildSuffix)

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
