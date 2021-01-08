# vpc
resource "google_compute_network" "vpc_network_mgmt" {
  name                    = "mgmt-network-${var.buildSuffix}"
  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
}
resource "google_compute_subnetwork" "vpc_network_mgmt_sub" {
  name          = "mgmt-subnet-${var.buildSuffix}"
  ip_cidr_range = "10.0.10.0/24"
  region        = var.gcpRegion
  network       = google_compute_network.vpc_network_mgmt.self_link

}
resource "google_compute_network" "vpc_network_int" {
  name                    = "internal-network-${var.buildSuffix}"
  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
}
resource "google_compute_subnetwork" "vpc_network_int_sub" {
  name          = "internal-subnet-${var.buildSuffix}"
  ip_cidr_range = "10.0.20.0/24"
  region        = var.gcpRegion
  network       = google_compute_network.vpc_network_int.self_link

}
resource "google_compute_network" "vpc_network_ext" {
  name                    = "external-network-${var.buildSuffix}"
  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
}
resource "google_compute_subnetwork" "vpc_network_ext_sub" {
  name          = "external-subnet-${var.buildSuffix}"
  ip_cidr_range = "10.0.30.0/24"
  region        = var.gcpRegion
  network       = google_compute_network.vpc_network_ext.self_link

}

#https://www.terraform.io/docs/providers/google/r/compute_router_nat.html
resource "google_compute_router" "router" {
  name    = "${var.prefix}-int-router"
  region  = google_compute_subnetwork.vpc_network_int_sub.region
  network = google_compute_network.vpc_network_int.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.prefix}-int-router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
