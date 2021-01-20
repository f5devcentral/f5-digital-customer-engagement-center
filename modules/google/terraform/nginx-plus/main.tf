# template
# Setup Onboarding scripts
data "template_file" "nginx_onboard" {
  template = file("${path.module}/templates/startup.sh.tpl")

  vars = {
    controllerAddress = var.controllerAddress
  }
}
resource "google_compute_instance_template" "nginx-template" {
  name_prefix = "nginx-template-"
  description = "This template is used to create runner server instances."

  instance_description = "nginx"
  machine_type         = "n1-standard-4"
  can_ip_forward       = false

  disk {
    source_image = "ubuntu-os-cloud/ubuntu-1804-lts"
    auto_delete  = true
    boot         = true
    type         = "pd-ssd"
  }
  network_interface {
    network    = var.vpc.id
    subnetwork = var.subnet.id
    access_config {
    }
    # how do?! needs to pick a free range for each new instance
    # alias_ip_range {
    #   ip_cidr_range         = cidrsubnet(google_container_cluster.primary.ip_allocation_policy.0.cluster_ipv4_cidr_block, 10, 203)
    #   subnetwork_range_name = google_container_cluster.primary.ip_allocation_policy.0.cluster_secondary_range_name
    # }
  }
  lifecycle {
    create_before_destroy = true
  }
  metadata = {
    ssh-keys       = "${var.adminAccountName}:${var.sshPublicKey}"
    startup-script = data.template_file.nginx_onboard.rendered
    #shutdown-script = "${file("${path.module}/templates/shutdown.sh")}"
  }
  service_account {
    email  = google_service_account.gce-nginx-sa.email
    scopes = ["cloud-platform"]
  }
}

# instance group 0
resource "google_compute_instance_group_manager" "nginx-group" {
  name               = "${var.prefix}-nginx-instance-group-manager"
  base_instance_name = "${var.prefix}-nginx"
  zone               = var.gcpZone
  target_size        = 1
  version {
    instance_template = google_compute_instance_template.nginx-template.id
  }
  # wait for gke cluster
  timeouts {
    create = "15m"
  }
}
