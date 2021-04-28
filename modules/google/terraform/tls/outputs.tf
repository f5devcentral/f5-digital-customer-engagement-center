output "tls_secret_key" {
  value       = module.tls_secret.secret_id
  description = <<EOD
The project-local Secret Manager key containing the TLS certificate, key, and CA.
EOD
}
