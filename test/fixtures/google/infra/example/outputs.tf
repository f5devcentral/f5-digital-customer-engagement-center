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

output "features" {
  value = var.features
}

output "vpc_options" {
  value = var.vpc_options
}

output "users" {
  value = var.users
}

output "expected_main_equiv" {
  value = var.expected_main_equiv
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

# Kitchen will fail to update outputs if the value is null/empty and prior test
# returned a non-empty value. Explicitly return undefined if infra module returns
# null or empty string.

output "registries" {
  value = module.example.registries
}
output "workstation" {
  value = module.example.workstation
}
