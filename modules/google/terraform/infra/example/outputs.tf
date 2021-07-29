output "vpcs" {
  value       = module.example.vpcs
  description = <<EOD
A map of VPC networks created by module, keyed by usage context.
EOD
}

output "subnets" {
  value       = module.example.subnets
  description = <<EOD
A map of subnetworks created by module, keyed by usage context.
EOD
}

output "registries" {
  value       = module.example.registries
  description = <<EOD
A JSON object containing registry attributes keyed by registry intent (e.g. container, npm, etc).
EOD
}

output "workstation" {
  value       = module.example.workstation
  description = <<EOD
A JSON object containing workstation attributes and connection helper commands from the embedded
workstation module.
EOD
}
