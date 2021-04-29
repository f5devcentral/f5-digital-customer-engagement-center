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

output "image" {
  value = var.image
}

# Outputs from the module under test
output "projectPrefix" {
  value = local.projectPrefix
}
output "self_link" {
  value = module.workstation.self_link
}

output "service_account" {
  value = module.workstation.service_account
}

output "connection_helpers" {
  value = module.workstation.connection_helpers
}

# Inspec
output "vpcs" {
  value = {
    main = module.vpc.network_self_link
  }
}

output "subnets" {
  value = {
    main = element(module.vpc.subnets_self_links, 0)
  }
}
