output "connection_helpers" {
  description = "gcloud connection helpers for GCP workstation(s)"
  value       = local.deploy_google ? module.google[0].connection_helpers : "{}"
}
