terraform {
  required_version = ">= 0.14.5"
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "0.8.1"
    }
  }
}


# Used to generate a random build suffix
resource "random_id" "build_suffix" {
  byte_length = 2
}

locals {
  # Allow user to specify a build suffix, but fallback to random as needed.
  build_suffix = coalesce(var.buildSuffix, random_id.build_suffix.hex)
  common_labels = {
    demo   = "multi-cloud-connectivity-volterra"
    owner  = var.resourceOwner
    prefix = var.projectPrefix
    suffix = local.build_suffix
  }
}


# Create a virtual site that will identify services deployed in AWS, Azure, and
# GCP.
resource "volterra_virtual_site" "site" {
  name        = format("%s-site-%s", var.projectPrefix, random_id.build_suffix.hex)
  namespace   = var.namespace
  description = format("Virtual site for %s-%s", var.projectPrefix, random_id.build_suffix.hex)
  labels      = local.common_labels
  annotations = {
    source      = "git::https://github.com/F5DevCentral/f5-digital-customer-engangement-center"
    provisioner = "terraform"
  }
  site_type = "CUSTOMER_EDGE"
  site_selector {
    expressions = [
      join(",", [for k, v in local.common_labels : format("%s = %s", k, v)])
    ]
  }
}
