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
  # NOTE: some GCP resources have name length limitations - try to keep this short
  projectPrefix = format("%s-in-%s", var.projectPrefix, var.variant)
}

module "infra" {
  source        = "../../../../modules/google/terraform/infra"
  projectPrefix = local.projectPrefix
  buildSuffix   = var.buildSuffix
  gcpRegion     = var.gcpRegion
  gcpProjectId  = var.gcpProjectId
  resourceOwner = var.resourceOwner
}
