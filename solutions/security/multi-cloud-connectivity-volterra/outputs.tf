output "connection_helpers" {
  description = "gcloud connection helpers for GCP workstation(s)"
  value       = local.deploy_google ? module.google[0].connection_helpers : "{}"
}

output "aws_jumphost_publicIP" {
  description = "AWS Jumphost Public IP in BU1"
  value       = local.deploy_aws ? module.aws[0].bu1JumphostPublicIp : "{}"
}
