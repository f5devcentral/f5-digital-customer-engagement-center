output "service_account" {
  value       = local.service_account
  description = <<EOD
The service account used by the server instances.
EOD
}

output "self_link" {
  value       = google_compute_instance.server.self_link
  description = <<EOD
The fully-qualifed self-link of the webserver instance.
EOD
}

output "addresses" {
  value = {
    private = google_compute_instance.server.network_interface[0].network_ip
    public  = var.public_address ? google_compute_instance.server.network_interface[0].access_config[0].nat_ip : null
  }
  description = <<EOD
The private IP address and public IP address assigned to the instance.
EOD
}

output "zone" {
  value       = google_compute_instance.server.zone
  description = <<EOD
The list of zone where the server is deployed.
EOD
}
