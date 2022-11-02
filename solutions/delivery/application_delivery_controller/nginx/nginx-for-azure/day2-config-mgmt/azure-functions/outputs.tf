output "functionUrl" {
  description = "Service URI of Function HTTP trigger endpoint"
  value       = local.function_url
  sensitive   = true
}
