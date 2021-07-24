output "connection_helpers" {
  value       = module.workstation.connection_helpers
  description = <<EOD
A set of `gcloud` commands to connect to SSH, setup a forward-proxy, and to access
Code Server on the workstation.
EOD
}
