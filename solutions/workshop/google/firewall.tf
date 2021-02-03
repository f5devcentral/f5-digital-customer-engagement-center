# firewall rules student 1
resource "google_compute_firewall" "default-allow-internal-mgmt" {
  name    = "${var.projectPrefix}-default-allow-internal-mgmt-firewall"
  network = module.google_network_1.vpcs["public"].name

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
  name    = "${var.projectPrefix}-mgmt-firewall${random_pet.buildSuffix.id}"
  network = module.google_network_1.vpcs["public"].name

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
  name    = "${var.projectPrefix}-iap-firewall-${random_pet.buildSuffix.id}"
  network = module.google_network_1.vpcs["public"].name

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "443", "80"]
  }

  source_ranges = ["35.235.240.0/20"]
}

// # firewall rules student 2
// resource "google_compute_firewall" "default-allow-internal-mgmt" {
//   name    = "${var.projectPrefix}-default-allow-internal-mgmt-firewall"
//   network = module.google_network_2.vpcs["public"].name

//   allow {
//     protocol = "icmp"
//   }

//   allow {
//     protocol = "tcp"
//     ports    = ["0-65535"]
//   }
//   allow {
//     protocol = "udp"
//     ports    = ["0-65535"]
//   }
//   priority = "65534"

//   #source_ranges = module.google_network.subnets["mgmt"]
//   source_ranges = ["10.0.10.0/24"]
// }
// resource "google_compute_firewall" "mgmt" {
//   name    = "${var.projectPrefix}-mgmt-firewall${random_pet.buildSuffix.id}"
//   network = module.google_network_2.vpcs["public"].name

//   allow {
//     protocol = "icmp"
//   }

//   allow {
//     protocol = "tcp"
//     ports    = ["22", "443", "80"]
//   }

//   source_ranges = var.adminSourceAddress
// }

// resource "google_compute_firewall" "iap-ingress" {
//   name    = "${var.projectPrefix}-iap-firewall-${random_pet.buildSuffix.id}"
//   network = module.google_network_2.vpcs["public"].name

//   allow {
//     protocol = "tcp"
//   }

//   allow {
//     protocol = "tcp"
//     ports    = ["22", "443", "80"]
//   }

//   source_ranges = ["35.235.240.0/20"]
// }
// # firewall rules student 3
// resource "google_compute_firewall" "default-allow-internal-mgmt" {
//   name    = "${var.projectPrefix}-default-allow-internal-mgmt-firewall"
//   network = module.google_network_3.vpcs["public"].name

//   allow {
//     protocol = "icmp"
//   }

//   allow {
//     protocol = "tcp"
//     ports    = ["0-65535"]
//   }
//   allow {
//     protocol = "udp"
//     ports    = ["0-65535"]
//   }
//   priority = "65534"

//   #source_ranges = module.google_network.subnets["mgmt"]
//   source_ranges = ["10.0.10.0/24"]
// }
// resource "google_compute_firewall" "mgmt" {
//   name    = "${var.projectPrefix}-mgmt-firewall${random_pet.buildSuffix.id}"
//   network = module.google_network_3.vpcs["public"].name

//   allow {
//     protocol = "icmp"
//   }

//   allow {
//     protocol = "tcp"
//     ports    = ["22", "443", "80"]
//   }

//   source_ranges = var.adminSourceAddress
// }

// resource "google_compute_firewall" "iap-ingress" {
//   name    = "${var.projectPrefix}-iap-firewall-${random_pet.buildSuffix.id}"
//   network = module.google_network_3.vpcs["public"].name

//   allow {
//     protocol = "tcp"
//   }

//   allow {
//     protocol = "tcp"
//     ports    = ["22", "443", "80"]
//   }

//   source_ranges = ["35.235.240.0/20"]
// }
