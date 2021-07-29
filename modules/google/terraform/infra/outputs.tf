output "vpcs" {
  value = merge(local.vpcs, {
    "main" = local.vpcs[local.aka_main]
  })
  description = <<EOD
A map of VPC networks created by module, keyed by usage context.
EOD
}

output "subnets" {
  value = merge(local.subnets, {
    "main" = local.subnets[local.aka_main]
  })
  description = <<EOD
A map of subnetworks created by module, keyed by usage context.
EOD
}

output "registries" {
  value = jsonencode({
    container = {
      id   = var.features.registry ? google_artifact_registry_repository.container.0.id : null
      repo = var.features.registry ? format("%s-docker.pkg.dev/%s", google_artifact_registry_repository.container.0.location, google_artifact_registry_repository.container.0.project) : null
    }
  })
  description = <<EOD
A JSON object containing registry attributes keyed by registry intent (e.g. container, npm, etc).
EOD
}

output "workstation" {
  value = jsonencode({
    self_link          = var.features.workstation ? module.workstation.0.self_link : null
    service_account    = var.features.workstation ? module.workstation.0.service_account : null
    tls_certs          = var.features.workstation ? jsondecode(module.workstation.0.tls_certs) : {}
    connection_helpers = var.features.workstation ? jsondecode(module.workstation.0.connection_helpers) : {}
  })
  description = <<EOD
A JSON object containing workstation attributes and connection helper commands from the embedded
workstation module.
EOD
}
