terraform {
  required_version = ">= 0.14.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.54"
    }
  }
}

module "infra" {
  source        = "../../infra"
  projectPrefix = var.projectPrefix
  buildSuffix   = var.buildSuffix
  gcpRegion     = var.gcpRegion
  gcpProjectId  = var.gcpProjectId
  resourceOwner = var.resourceOwner
  features = {
    workstation = false
    isolated    = false
    registry    = false
  }
  vpc_options = {
    mgmt    = null
    private = null
    public = {
      primary_cidr = "172.16.0.0/16",
      mtu          = 1460,
      nat          = false
    }
  }
}

module "server" {
  source         = "../"
  projectPrefix  = var.projectPrefix
  buildSuffix    = var.buildSuffix
  gcpProjectId   = var.gcpProjectId
  resourceOwner  = var.resourceOwner
  subnet         = module.infra.subnets["main"]
  public_address = true
}

resource "google_compute_firewall" "server" {
  project = var.gcpProjectId
  name    = format("%s-public-webserver-%s", var.projectPrefix, var.buildSuffix)
  network = module.infra.vpcs["main"]
  source_ranges = [
    "0.0.0.0/0",
  ]
  target_service_accounts = [
    module.server.service_account,
  ]

  allow {
    protocol = "TCP"
    ports = [
      22,
      80,
    ]
  }
}
