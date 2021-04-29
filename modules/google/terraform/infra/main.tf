terraform {
  required_version = "~> 0.14.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.54"
    }
  }
}

# Determine the set of APIs to enable based on behavioural features
locals {
  apis = compact(concat(
    # Base set of APIs to enable
    [
      "compute.googleapis.com",
      "iam.googleapis.com",
      "iap.googleapis.com",
      "oslogin.googleapis.com",
      "storage-api.googleapis.com",
      "secretmanager.googleapis.com",
      "cloudresourcemanager.googleapis.com",
    ],
    # If private access is needed for subnets the project will need DNS enabled
    var.features.isolated ? [
      "dns.googleapis.com",
    ] : [],
    # Enable artifact registry and scanning APIs
    var.features.registry ? [
      "artifactregistry.googleapis.com",
      "containerscanning.googleapis.com",
    ] : []
  ))
  # Add the resource owner to common labels
  labels = merge(var.labels, {
    owner = var.resourceOwner
  })
}

# Ensure that the required APIs are enabled in the project; note that these will
# be enabled on create as needed, but never disabled/deleted on destroy. This
# prevents user A from breaking the deployment of user B in a shared project.
resource "google_project_service" "apis" {
  for_each                   = toset(local.apis)
  project                    = var.gcpProjectId
  service                    = each.value
  disable_dependent_services = false
  disable_on_destroy         = false
}

# Provision a workstation instance on 'main' subnet
module "workstation" {
  source        = "../workstation/"
  count         = var.features.workstation ? 1 : 0
  projectPrefix = var.projectPrefix
  buildSuffix   = var.buildSuffix
  gcpProjectId  = var.gcpProjectId
  gcpRegion     = var.gcpRegion
  resourceOwner = var.resourceOwner
  labels        = local.labels
  subnet        = local.subnets[local.aka_main]
}
