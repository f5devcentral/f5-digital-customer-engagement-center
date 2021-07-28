output "service_account" {
  value       = module.workstation.service_account
  description = <<EOD
The service account used by workstation instance.
EOD
}

output "self_link" {
  value       = module.workstation.self_link
  description = <<EOD
The fully-qualifed self-link of the workstation instance.
EOD
}

output "connection_helpers" {
  value       = module.workstation.connection_helpers
  description = <<EOD
A set of gcloud commands to create IAP tunnels for direct access to Code Server,
proxying to protected resources, and starting an SSH session. See the README for
details.
EOD
}
