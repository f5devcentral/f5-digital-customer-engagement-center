terraform {
  required_version = "~> 0.14.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.54"
    }
  }
}

resource "random_pet" "projectPrefix" {
  length = 1
  keepers = {
    gcpProjectId = var.gcpProjectId
  }
}

resource "random_id" "buildSuffix" {
  byte_length = 2
  keepers = {
    gcpProjectId = var.gcpProjectId
  }
}

# Generate a harness.tfvars file that will be used to seed fixtures
resource "local_file" "harness_tfvars" {
  filename = "${path.module}/harness.tfvars"
  content  = <<EOT
# Common parameters
projectPrefix = "${random_pet.projectPrefix.id}"
buildSuffix = "${random_id.buildSuffix.hex}"
resourceOwner = "${var.resourceOwner}"

# AWS parameters

# Azure parameters

# GCP parameters
%{if var.gcpProjectId != ""}gcpProjectId = "${var.gcpProjectId}"%{endif}
EOT
}
