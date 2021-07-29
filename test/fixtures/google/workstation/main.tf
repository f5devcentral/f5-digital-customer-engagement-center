terraform {
  required_version = "~> 0.14.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.54"
    }
  }
}

locals {
  projectPrefix = format("%s-wks-%s", var.projectPrefix, var.variant)
}

# Workstation module needs a VPC subnet to attach too
module "vpc" {
  source                                 = "terraform-google-modules/network/google"
  version                                = "3.0.1"
  project_id                             = var.gcpProjectId
  network_name                           = format("%s-workstation-vpc-%s", local.projectPrefix, var.buildSuffix)
  description                            = "Workstation testing VPC"
  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = false
  mtu                                    = 1460
  routing_mode                           = "REGIONAL"
  subnets = [
    {
      subnet_name           = format("%s-workstation-subnet-%s", local.projectPrefix, var.buildSuffix)
      subnet_ip             = "192.168.0.0/24"
      subnet_region         = var.gcpRegion
      subnet_private_access = false
    }
  ]
}

# Workstation is intended to function without a public IP, so provision a NAT
# for software installation from public internet
module "nat" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "0.4.0"
  project = var.gcpProjectId
  region  = var.gcpRegion
  name    = format("%s-workstation-router-%s", local.projectPrefix, var.buildSuffix)
  network = module.vpc.network_self_link
  nats = [{
    name = format("%s-workstation-nat-%s", local.projectPrefix, var.buildSuffix)
  }]
}

module "workstation" {
  source        = "../../../../modules/google/terraform/workstation/"
  projectPrefix = local.projectPrefix
  buildSuffix   = var.buildSuffix
  gcpProjectId  = var.gcpProjectId
  gcpRegion     = var.gcpRegion
  resourceOwner = var.resourceOwner
  subnet        = element(module.vpc.subnets_self_links, 0)
  users         = var.users
}
