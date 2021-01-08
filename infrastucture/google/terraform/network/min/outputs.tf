locals {
  vpcs = {
    "main"    = google_compute_network.vpc_network_mgmt
    "mgmt"    = google_compute_network.vpc_network_mgmt
    "public"  = google_compute_network.vpc_network_ext
    "private" = google_compute_network.vpc_network_int
  }
  subnets = {
    "mgmt"    = google_compute_subnetwork.vpc_network_mgmt_sub
    "public"  = google_compute_subnetwork.vpc_network_ext_sub
    "private" = google_compute_subnetwork.vpc_network_int_sub
  }
}

output "vpcs" {
  value = local.vpcs
}

output "subnets" {
  value = local.subnets
}
