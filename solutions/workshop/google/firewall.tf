# firewall rules student 1
resource "google_compute_firewall" "default-allow-internal-mgmt" {
  for_each = var.students
  name     = "${each.value.projectPrefix}-default-allow-internal-mgmt-firewall"
  network  = module.google_network[each.key].vpcs["public"].name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  priority = "65534"

  #source_ranges = module.google_network.subnets["mgmt"]
  source_ranges = ["10.0.10.0/24"]
}
resource "google_compute_firewall" "mgmt" {
  for_each = var.students
  name     = "${each.value.projectPrefix}-mgmt-firewall${random_pet.buildSuffix.id}"
  network  = module.google_network[each.key].vpcs["public"].name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "443", "80"]
  }

  source_ranges = var.adminSourceAddress
}

resource "google_compute_firewall" "iap-ingress" {
  for_each = var.students
  name     = "${each.value.projectPrefix}-iap-firewall-${random_pet.buildSuffix.id}"
  network  = module.google_network[each.key].vpcs["public"].name

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "443", "80"]
  }

  source_ranges = ["35.235.240.0/20"]
}
