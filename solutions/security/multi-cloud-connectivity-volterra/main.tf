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

# Used to generate a random build suffix
resource "random_id" "build_suffix" {
  byte_length = 2
}

locals {
  # TODO: @memes - TF cannot apply if build suffix is randomly generated; insist
  # on user supplied buildSuffix, or add to setup.sh/demo.sh and secondary
  # tfvars file?
  #build_suffix = coalesce(var.buildSuffix, random_id.build_suffix.hex)
  common_labels = {
    demo   = "multi-cloud-connectivity-volterra"
    owner  = var.resourceOwner
    prefix = var.projectPrefix
    suffix = var.buildSuffix
  }
  deploy_aws    = coalesce(var.awsRegion, "x") != "x"
  deploy_azure  = coalesce(var.azureLocation, "x") != "x"
  deploy_google = coalesce(var.gcpProjectId, "x") != "x" && coalesce(var.gcpRegion, "x") != "x"
}

# module "aws" {
#   count = local.deploy_aws ?  1 : 0
#   source = "./aws/"
#   projectPrefix = var.projectPrefix
# }

# module "azure" {
#   count = local.deploy_azure ?  1 : 0
#   source = "./azure/"
#   projectPrefix = var.projectPrefix
# }

module "google" {
  count              = local.deploy_google ? 1 : 0
  source             = "./google/"
  projectPrefix      = var.projectPrefix
  buildSuffix        = local.build_suffix
  gcpRegion          = var.gcpRegion
  gcpProjectId       = var.gcpProjectId
  resourceOwner      = var.resourceOwner
  volterra_namespace = var.volterra_namespace
  volterraTenant     = var.volterraTenant
  ssh_key            = var.ssh_key
  domain_name        = var.domain_name
  labels             = local.common_labels
}
