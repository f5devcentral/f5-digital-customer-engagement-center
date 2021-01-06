#https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/8.1.0?tab=inputs
resource "google_container_cluster" "primary" {
  count                     = var.kubernetes ? 1 : 0
  name                      = "${var.prefix}gke-cluster${random_pet.buildSuffix.id}"
  location                  = var.gcpZone
  node_version              = var.gkeVersion
  min_master_version        = var.gkeVersion
  default_max_pods_per_node = "110"
  #cluster_ipv4_cidr = var.podCidr
  ip_allocation_policy {}
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.vpc_network_int.id
  subnetwork               = google_compute_subnetwork.vpc_network_int_sub.id
  // master_auth {
  //   username = var.adminAccount
  //   password = var.adminPassword
  //   client_certificate_config {
  //     issue_client_certificate = true
  //   }
  // }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  count      = var.kubernetes ? 1 : 0
  name       = "${var.prefix}node-pool${random_pet.buildSuffix.id}"
  location   = var.gcpZone
  cluster    = google_container_cluster.primary[0].name
  node_count = 3

  node_config {
    image_type   = "COS"
    preemptible  = true
    machine_type = "n1-standard-1"
    disk_type    = "pd-standard"
    disk_size_gb = 100
    metadata = {
      disable-legacy-endpoints = "true"
    }
    oauth_scopes = [
      #https://cloud.google.com/container-registry/docs/access-control
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
