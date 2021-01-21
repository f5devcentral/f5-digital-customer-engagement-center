# startup script
data "http" "template_onboard" {
  url = var.onboardScript
}

data "template_file" "vm_onboard" {
  template = data.http.template_onboard.body

  vars = {
    repositories = var.repositories
    user         = var.adminAccountName
  }
}
# disk
resource "google_compute_disk" "workspace_disk" {
  name                      = "${var.prefix}workspace-disk${var.buildSuffix}"
  type                      = "pd-ssd"
  image                     = var.deviceImage
  physical_block_size_bytes = 4096
  size                      = "20"
}
resource "google_compute_image" "workspace_image" {
  name         = "${var.prefix}workspace${var.buildSuffix}"
  family       = "ubuntu-2004-lts"
  disk_size_gb = "20"
  project      = var.gcpProjectId
  licenses = ["https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx",
  "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/licenses/ubuntu-2004-lts"]
  source_disk = google_compute_disk.workspace_disk.self_link
}

# GCE instance
resource "google_compute_instance" "vm_instance" {
  count            = var.vm_count
  name             = "${var.prefix}${var.name}-${count.index + 1}-instance${var.buildSuffix}"
  machine_type     = var.machineType
  min_cpu_platform = "Intel Haswell"

  boot_disk {
    initialize_params {
      image = google_compute_image.workspace_image.name
    }
  }

  metadata = {
    ssh-keys               = "${var.adminAccountName}:${var.sshPublicKey}"
    block-project-ssh-keys = true
    # this is best for a long running instance as it is only evaulated and run once, changes to the template do NOT destroy the running instance.
    #startup-script = data.template_file.vm_onboard.rendered
    deviceId = count.index + 1
  }
  # this is best for dev, as it runs ANY time there are changes and DESTROYS the instances
  metadata_startup_script = data.template_file.vm_onboard.rendered

  network_interface {
    # mgmt
    # A default network is created for all GCP projects
    network    = var.vpc.name
    subnetwork = var.subnet.name
    # network = google_compute_network.vpc_network.self_link
    access_config {
    }
  }
  service_account {
    # https://cloud.google.com/sdk/gcloud/reference/alpha/compute/instances/set-scopes#--scopes
    #email = "${var.sa_name}"
    scopes = ["storage-rw", "logging-write", "monitoring-write", "monitoring", "pubsub", "service-management", "service-control"]
    # scopes = [ "storage-ro"]
  }

}
