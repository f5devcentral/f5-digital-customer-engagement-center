# Create three VPC networks in project for use with multi-leg deployments

terraform {
  required_version = "~> 0.14.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.54"
    }
  }
}

module "mgmt" {
  source                                 = "terraform-google-modules/network/google"
  version                                = "3.0.1"
  project_id                             = var.gcpProjectId
  network_name                           = format("%s-mgmt-vpc-%s", var.projectPrefix, var.buildSuffix)
  description                            = "Management VPC"
  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = false
  mtu                                    = 1460
  routing_mode                           = "REGIONAL"
  subnets = [
    {
      subnet_name           = format("%s-mgmt-subnet-%s", var.projectPrefix, var.buildSuffix)
      subnet_ip             = "10.0.10.0/24"
      subnet_region         = var.gcpRegion
      subnet_private_access = false
    }
  ]
}

module "private" {
  source       = "terraform-google-modules/network/google"
  version      = "3.0.1"
  project_id   = var.gcpProjectId
  network_name = format("%s-private-vpc-%s", var.projectPrefix, var.buildSuffix)

  description                            = "Private VPC"
  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = false
  mtu                                    = 1460
  routing_mode                           = "REGIONAL"
  subnets = [
    {
      subnet_name           = format("%s-private-subnet-%s", var.projectPrefix, var.buildSuffix)
      subnet_ip             = "10.0.20.0/24"
      subnet_region         = var.gcpRegion
      subnet_private_access = false
    }
  ]
}

module "public" {
  source       = "terraform-google-modules/network/google"
  version      = "3.0.1"
  project_id   = var.gcpProjectId
  network_name = format("%s-public-vpc-%s", var.projectPrefix, var.buildSuffix)

  description                            = "External VPC"
  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = false
  mtu                                    = 1460
  routing_mode                           = "REGIONAL"
  subnets = [
    {
      subnet_name           = format("%s-public-subnet-%s", var.projectPrefix, var.buildSuffix)
      subnet_ip             = "10.0.30.0/24"
      subnet_region         = var.gcpRegion
      subnet_private_access = false
    }
  ]
}

module "nat" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "0.4.0"
  project = var.gcpProjectId
  region  = var.gcpRegion
  name    = format("%s-mgmt-router-%s", var.projectPrefix, var.buildSuffix)
  network = module.mgmt.network_self_link
  nats = [{
    name = format("%s-mgmt-nat-%s", var.projectPrefix, var.buildSuffix)
  }]
}
