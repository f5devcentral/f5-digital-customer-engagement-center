# firewall rules
resource "google_compute_firewall" "default-allow-internal-mgmt" {
  name    = "${var.prefix}-default-allow-internal-mgmt-firewall"
  network = module.google_network.vpcs["mgmt"].name

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
  name    = "${var.prefix}-mgmt-firewall${random_pet.buildSuffix.id}"
  network = module.google_network.vpcs["mgmt"].name

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
  name    = "${var.prefix}-iap-firewall-${random_pet.buildSuffix.id}"
  network = module.google_network.vpcs["mgmt"].name

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "443", "80"]
  }

  source_ranges = ["35.235.240.0/20"]
}
