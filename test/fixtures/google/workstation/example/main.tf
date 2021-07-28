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
  projectPrefix = format("%s-wks-ex", var.projectPrefix)
}

module "example" {
  source        = "../../../../../modules/google/terraform/workstation/example/"
  projectPrefix = local.projectPrefix
  buildSuffix   = var.buildSuffix
  gcpRegion     = var.gcpRegion
  gcpProjectId  = var.gcpProjectId
  resourceOwner = var.resourceOwner
}
