#
# Fixture outputs - these are made available to inspec profiles as 'output_NAME'
#

# Mirror inputs to outputs; allows the test suites inspect Terraform vars
# regardless of how they were set
output "buildSuffix" {
  value = var.buildSuffix
}

output "gcpRegion" {
  value = var.gcpRegion
}

output "gcpProjectId" {
  value = var.gcpProjectId
}
output "resourceOwner" {
  value = var.resourceOwner
}

# Outputs from the module under test
output "projectPrefix" {
  value = local.projectPrefix
}
output "vpcs" {
  value = module.example.vpcs
}

output "subnets" {
  value = module.example.subnets
}
