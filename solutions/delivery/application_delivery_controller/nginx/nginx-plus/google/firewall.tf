# firewall
# mgmt
resource "google_compute_firewall" "mgmt" {
  name    = "${var.prefix}mgmt-firewall-${random_pet.buildSuffix.id}"
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

resource "google_compute_firewall" "nginx-mgmt" {
  name    = "${var.prefix}nginx-firewall-${random_pet.buildSuffix.id}"
  network = module.google_network.vpcs["public"].name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.adminSourceAddress
}

resource "google_compute_firewall" "default-allow-internal-int" {
  name    = "${var.prefix}-default-allow-internal-int-${random_pet.buildSuffix.id}"
  network = module.google_network.vpcs["private"].name

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

  source_ranges = ["10.0.20.0/24"]
}
resource "google_compute_firewall" "allow-internal-egress" {
  name      = "${var.prefix}-allow-internal-egress-${random_pet.buildSuffix.id}"
  network   = module.google_network.vpcs["public"].name
  direction = "EGRESS"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  priority = "65533"

  destination_ranges = ["10.0.20.0/24"]
}

resource "google_compute_firewall" "app" {
  name    = "${var.prefix}-app-${random_pet.buildSuffix.id}"
  network = module.google_network.vpcs["public"].name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = var.adminSourceAddress
}

resource "google_compute_firewall" "iap-ingress" {
  name    = "${var.prefix}-iap-firewall-${random_pet.buildSuffix.id}"
  network = module.google_network.vpcs["private"].name

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "443", "80"]
  }

  source_ranges = ["35.235.240.0/20"]
}
