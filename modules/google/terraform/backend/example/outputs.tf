output "service_account" {
  value       = module.server.service_account
  description = <<EOD
The service account used by the server instances.
EOD
}

output "self_link" {
  value       = module.server.self_link
  description = <<EOD
The fully-qualifed self-link of the server instance.
EOD
}

output "addresses" {
  value       = module.server.addresses
  description = <<EOD
The IP address of the server.
EOD
}
