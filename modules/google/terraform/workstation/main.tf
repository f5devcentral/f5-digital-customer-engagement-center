terraform {
  required_version = ">= 0.14.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.54"
    }
  }
}

locals {
  labels = merge(var.labels, {
    owner   = var.resourceOwner
    purpose = "workstation"
  })
  name            = coalesce(var.name, format("%s-wkstn-%s-%s", var.projectPrefix, random_id.nonce.hex, var.buildSuffix))
  zone            = coalesce(var.zone, random_shuffle.zones.result[0])
  service_account = coalesce(var.service_account, format("%s-wkstn-%s@%s.iam.gserviceaccount.com", var.projectPrefix, var.buildSuffix, var.gcpProjectId))
}

resource "random_id" "nonce" {
  byte_length = 2
}

data "google_compute_subnetwork" "main" {
  self_link = var.subnet
}

# Deploy the workstation VM to a zone in the same region as the subnet
data "google_compute_zones" "zones" {
  project = var.gcpProjectId
  region  = var.gcpRegion
  status  = "UP"
}

resource "random_shuffle" "zones" {
  input = data.google_compute_zones.zones.names
  keepers = {
    gcpProjectId = var.gcpProjectId
  }
}

# Fallback to latest Ubuntu Focal LTS image published by GCP if a specific image
# isn't provided.
data "google_compute_image" "default" {
  project = "ubuntu-os-cloud"
  family  = "ubuntu-2004-lts"
}

# NOTE: normally @memes recommends use of Google's bastion host TF module, but it
# cannot reliably work with DCEC dynamic naming approach (projectPrefix & buildSuffix)
# in the init/plan/apply cycle used by shell scripts.

# Create a service account for workstation with OSLogin support
module "sa" {
  count        = coalesce(var.service_account, "x") == "x" ? 1 : 0
  source       = "terraform-google-modules/service-accounts/google"
  version      = "4.0.0"
  project_id   = var.gcpProjectId
  prefix       = var.projectPrefix
  names        = [format("wkstn-%s", var.buildSuffix)]
  descriptions = [format("Workstation for %s (%s)", var.projectPrefix, var.buildSuffix)]
  project_roles = [
    "${var.gcpProjectId}=>roles/logging.logWriter",
    "${var.gcpProjectId}=>roles/monitoring.metricWriter",
    "${var.gcpProjectId}=>roles/monitoring.viewer",
    "${var.gcpProjectId}=>roles/compute.osLogin",
  ]
  generate_keys = false
}

# If a tls_secret_key is not provided, generate a self-signed cert to use with
# workstation instance.
module "tls_secret" {
  count                   = var.tls_secret_key != "" ? 0 : 1
  source                  = "../tls/"
  gcpProjectId            = var.gcpProjectId
  secret_manager_key_name = format("%s-wkstn-tls-%s", var.projectPrefix, var.buildSuffix)
  secret_accessors = [
    format("serviceAccount:%s", local.service_account),
  ]
}

# Provision the workstation instance
resource "google_compute_instance" "workstation" {
  project = var.gcpProjectId
  name    = local.name
  zone    = local.zone
  labels  = local.labels
  metadata = {
    enable-oslogin = "TRUE"
    user-data = templatefile("${path.module}/templates/cloud-config.yml", {
      tls_secret_key                   = compact(concat([var.tls_secret_key], module.tls_secret[*].tls_secret_key))[0]
      install_workstation_tls_certs_sh = base64gzip(file("${path.module}/files/install-workstation-tls-certs.sh"))
      install_code_server_extension_sh = base64gzip(file("${path.module}/files/install-code-server-extension.sh"))
      terraform_version                = var.terraform_version
      code_server_version              = var.code_server_version
      code_server_extension_urls       = var.code_server_extension_urls
      git_repos                        = var.git_repos
    })
  }

  # Scheduling options
  #min_cpu_platform = var.min_cpu_platform
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
      image = data.google_compute_image.default.self_link
    }
  }

  # Networking - single interface with ephemerdal internal IP, no public NAT
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

data "google_service_account" "sa" {
  account_id = local.service_account
  project    = var.gcpProjectId
  depends_on = [
    module.sa,
  ]
}

# Bind list of workstation users as the *only* ones allowed to act-as workstation
# service account. Authoritative for *this* service account.
resource "google_service_account_iam_binding" "workstation" {
  count              = length(var.users) > 0 ? 1 : 0
  service_account_id = data.google_service_account.sa.name
  role               = "roles/iam.serviceAccountUser"
  members            = formatlist("user:%s", var.users)
}

# Bind list of workstation users as the *only* ones allowed to access workstation
# via IAP tunnel. Authoritative for *this* workstation instance.
resource "google_iap_tunnel_instance_iam_binding" "workstation" {
  count    = length(var.users) > 0 ? 1 : 0
  project  = google_compute_instance.workstation.project
  zone     = google_compute_instance.workstation.zone
  instance = google_compute_instance.workstation.name
  role     = "roles/iap.tunnelResourceAccessor"
  members  = formatlist("user:%s", var.users)
}

resource "google_compute_firewall" "iap" {
  project = var.gcpProjectId
  name    = format("%s-iap-wkstn-%s-%s", var.projectPrefix, random_id.nonce.hex, var.buildSuffix)
  network = data.google_compute_subnetwork.main.network
  source_ranges = [
    "35.235.240.0/20",
  ]
  target_service_accounts = [local.service_account]

  allow {
    protocol = "TCP"
    ports = [
      22,
      443,
      8888,
    ]
  }
}
