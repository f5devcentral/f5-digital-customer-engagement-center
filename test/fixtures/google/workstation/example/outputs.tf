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

output "users" {
  value = var.users
}

# Outputs from the module under test
output "projectPrefix" {
  value = local.projectPrefix
}
output "self_link" {
  value = module.example.self_link
}

output "service_account" {
  value = module.example.service_account
}

output "connection_helpers" {
  value = module.example.connection_helpers
}

# Inspec - example module does not return this value so send a fake that the
# controls can use
output "vpcs" {
  value = {
    main = "undefined"
  }
}

output "subnets" {
  value = {
    main = "undefined"
  }
}
