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
  user_data = coalesce(var.user_data, templatefile("${path.module}/templates/cloud-config.yml", {
    tls_secret_key              = var.tls_secret_key
    f5_logo_rgb_svg             = base64gzip(file("${path.module}/files/f5-logo-rgb.svg"))
    styles_css                  = base64gzip(file("${path.module}/files/styles.css"))
    install_server_tls_certs_sh = base64gzip(file("${path.module}/files/install-server-tls-certs.sh"))
  }))
  name            = coalesce(var.name, format("%s-server-%s", var.projectPrefix, var.buildSuffix))
  zone            = coalesce(var.zone, random_shuffle.zones.result[0])
  image           = coalesce(var.image, data.google_compute_image.default.self_link)
  service_account = coalesce(var.service_account, data.google_compute_default_service_account.default.email)
}

data "google_compute_subnetwork" "main" {
  self_link = var.subnet
}

# Deploy the backend VMs to a zone in the same region as the subnet if specific
# zones are not provided by caller.
data "google_compute_zones" "zones" {
  project = var.gcpProjectId
  region  = data.google_compute_subnetwork.main.region
  status  = "UP"
}

resource "random_shuffle" "zones" {
  input = data.google_compute_zones.zones.names
  keepers = {
    gcpProjectId = var.gcpProjectId
  }
}

# Fallback to latest COS image
data "google_compute_image" "default" {
  project = "cos-cloud"
  family  = "cos-stable"
}

# Get the default compute service account; the VMs will use this if no specific
# service account is provided.
data "google_compute_default_service_account" "default" {
  project = var.gcpProjectId
}

# Provision the server instance
resource "google_compute_instance" "server" {
  project = var.gcpProjectId
  name    = local.name
  zone    = local.zone
  labels = merge(var.labels, {
    owner   = var.resourceOwner
    purpose = "backend"
  })
  metadata = {
    enable-oslogin = "TRUE"
    user-data      = local.user_data
  }

  machine_type = var.machine_type
  service_account {
    email = local.service_account
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
  scheduling {
    automatic_restart = !var.preemptible
    preemptible       = var.preemptible
  }

  boot_disk {
    auto_delete = true
    initialize_params {
      type  = var.disk_type
      size  = var.disk_size_gb
      image = local.image
    }
  }

  tags           = var.tags
  can_ip_forward = false
  network_interface {
    subnetwork = data.google_compute_subnetwork.main.self_link
    dynamic "access_config" {
      for_each = compact(var.public_address ? [1] : [])
      content {
      }
    }
  }
}
