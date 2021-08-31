output "service_account" {
  value       = local.service_account
  description = <<EOD
The service account used by workstation instance.
EOD
}

output "self_link" {
  value       = google_compute_instance.workstation.self_link
  description = <<EOD
The fully-qualifed self-link of the workstation instance.
EOD
}

output "connection_helpers" {
  value = jsonencode({
    code_server_tunnel = format("gcloud compute start-iap-tunnel %s 443 --local-host-port=localhost:8443 --project=%s --zone=%s", google_compute_instance.workstation.name, google_compute_instance.workstation.project, google_compute_instance.workstation.zone)
    proxy_tunnel       = format("gcloud compute start-iap-tunnel %s 8888 --local-host-port=localhost:8888 --project=%s --zone=%s", google_compute_instance.workstation.name, google_compute_instance.workstation.project, google_compute_instance.workstation.zone)
    ssh                = format("gcloud compute ssh %s --tunnel-through-iap --project=%s --zone=%s", google_compute_instance.workstation.name, google_compute_instance.workstation.project, google_compute_instance.workstation.zone)
  })
  description = <<EOD
A JSON object containing Google SDK commands to connect to workstation instance for various tasks:
    code_server_tunnel: gcloud command to create an IAP-tunnel to code-server
                        running on workstation. Execute command and browse to
                        https://localhost:8443/ to access code-server.
    proxy_tunnel: gcloud command to create an IAP-tunnel that can be used as an
                  HTTPS_PROXY for non-public GCP resources such as BIG-IP, NGINX,
                  and GKE. Execute command and set your browser to use
                  https://localhost:8888/ as HTTPS proxy.
    ssh: gcloud command to SSH to workstation using IAP to establish credentials.
EOD
}
