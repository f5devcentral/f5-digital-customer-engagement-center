output "connection_helpers" {
  value       = { for k, v in module.workstation : k => v.connection_helpers }
  description = <<EOD
A set of `gcloud` commands to connect to SSH, setup a forward-proxy, and to access
Code Server on each workstation, mapped by business unit.
EOD
}
