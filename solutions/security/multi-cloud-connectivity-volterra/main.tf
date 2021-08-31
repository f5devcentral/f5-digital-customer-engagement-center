terraform {
  required_version = ">= 0.14.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.69"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 3.77"
    }
    volterra = {
      source  = "volterraedge/volterra"
      version = "0.8.1"
    }
  }
}

provider "aws" {
  region = var.awsRegion
}

provider "azurerm" {
  features {}
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
  deploy_aws    = coalesce(var.awsRegion, "x") != "x" && coalesce(var.volterraCloudCredAWS, "x") != "x"
  deploy_azure  = coalesce(var.azureLocation, "x") != "x" && coalesce(var.volterraCloudCredAzure, "x") != "x"
  deploy_google = coalesce(var.gcpProjectId, "x") != "x" && coalesce(var.gcpRegion, "x") != "x" && coalesce(var.volterraCloudCredGCP, "x") != "x"
}


# Create a virtual site that will identify services deployed in AWS, Azure, and
# GCP.
resource "volterra_virtual_site" "site" {
  name        = format("%s-site-%s", var.projectPrefix, local.build_suffix)
  namespace   = var.namespace
  description = format("Virtual site for %s-%s", var.projectPrefix, local.build_suffix)
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

module "aws" {
  count               = local.deploy_aws ? 1 : 0
  source              = "./aws/"
  projectPrefix       = var.projectPrefix
  volterraVirtualSite = volterra_virtual_site.site.name
  domain_name         = var.domain_name
  ssh_key             = var.ssh_key
  buildSuffix         = local.build_suffix
  namespace           = var.namespace
  resourceOwner       = var.resourceOwner
  awsRegion           = var.awsRegion
  volterraTenant      = var.volterraTenant
  volterraCloudCred   = var.volterraCloudCredAWS
  labels              = local.common_labels
}

module "azure" {
  count               = local.deploy_azure ? 1 : 0
  source              = "./azure/"
  projectPrefix       = var.projectPrefix
  volterraVirtualSite = volterra_virtual_site.site.name
  domain_name         = var.domain_name
  buildSuffix         = local.build_suffix
  namespace           = var.namespace
  resourceOwner       = var.resourceOwner
  azureLocation       = var.azureLocation
  volterraTenant      = var.volterraTenant
  ssh_key             = var.ssh_key
  volterraCloudCred   = var.volterraCloudCredAzure
  labels              = local.common_labels
}

module "google" {
  count               = local.deploy_google ? 1 : 0
  source              = "./google/"
  projectPrefix       = var.projectPrefix
  buildSuffix         = local.build_suffix
  gcpRegion           = var.gcpRegion
  gcpProjectId        = var.gcpProjectId
  resourceOwner       = var.resourceOwner
  namespace           = var.namespace
  volterraTenant      = var.volterraTenant
  ssh_key             = var.ssh_key
  domain_name         = var.domain_name
  labels              = local.common_labels
  volterraVirtualSite = volterra_virtual_site.site.name
  volterraCloudCred   = var.volterraCloudCredGCP
}
