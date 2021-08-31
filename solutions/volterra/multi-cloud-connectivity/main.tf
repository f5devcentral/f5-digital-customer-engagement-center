terraform {
  required_version = ">= 0.14.5"
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "0.10"
    }
  }
}


# Used to generate a random build suffix
resource "random_id" "buildSuffix" {
  byte_length = 2
}

locals {
  # Allow user to specify a build suffix, but fallback to random as needed.
  buildSuffix = coalesce(var.buildSuffix, random_id.buildSuffix.hex)
  commonLabels = {
    demo   = "multi-cloud-connectivity-volterra"
    owner  = var.resourceOwner
    prefix = var.projectPrefix
    suffix = local.buildSuffix
  }
}


# Create a virtual site that will identify services deployed in AWS, Azure, and
# GCP.
resource "volterra_virtual_site" "site" {
  name        = format("%s-site-%s", var.projectPrefix, local.buildSuffix)
  namespace   = var.namespace
  description = format("Virtual site for %s-%s", var.projectPrefix, local.buildSuffix)
  labels      = local.commonLabels
  annotations = {
    source      = "git::https://github.com/F5DevCentral/f5-digital-customer-engangement-center"
    provisioner = "terraform"
  }
  site_type = "CUSTOMER_EDGE"
  site_selector {
    expressions = [
      join(",", [for k, v in local.commonLabels : format("%s = %s", k, v)])
    ]
  }
}
