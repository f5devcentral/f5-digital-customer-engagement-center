terraform {
  required_version = "~> 0.14.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.54"
    }
  }
}

module "network" {
  source        = "../"
  projectPrefix = var.projectPrefix
  buildSuffix   = var.buildSuffix
  gcpRegion     = var.gcpRegion
  gcpProjectId  = var.gcpProjectId
  resourceOwner = var.resourceOwner
}
