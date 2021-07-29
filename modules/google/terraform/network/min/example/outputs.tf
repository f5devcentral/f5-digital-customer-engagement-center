output "vpcs" {
  value       = module.network.vpcs
  description = <<EOD
A map of VPC networks created by module, keyed by usage context.
EOD
}

output "subnets" {
  value       = module.network.subnets
  description = <<EOD
A map of subnetworks created by module, keyed by usage context.
EOD
}
