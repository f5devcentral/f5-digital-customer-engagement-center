# If the module consumer has requested an isolated configuration then DNS for
# googleapis.com endpoints is required.

module "googleapis" {
  count       = var.features.isolated ? 1 : 0
  source      = "terraform-google-modules/cloud-dns/google"
  version     = "3.1.0"
  project_id  = var.gcpProjectId
  type        = "private"
  name        = format("%s-restricted-googleapis-%s", var.projectPrefix, var.buildSuffix)
  domain      = "googleapis.com."
  description = "Override googleapis.com domain to use restricted.googleapis.com"
  labels = merge(local.labels, {
    purpose = "private-google-api-access"
  })
  private_visibility_config_networks = values(local.vpcs)
  recordsets = [
    {
      name = "*"
      type = "CNAME"
      ttl  = 300
      records = [
        "restricted.googleapis.com.",
      ]
    },
    {
      name = "restricted"
      type = "A"
      ttl  = 300
      records = [
        "199.36.153.4",
        "199.36.153.5",
        "199.36.153.6",
        "199.36.153.7",
      ]
    }
  ]
}

module "gcr" {
  count       = var.features.isolated ? 1 : 0
  source      = "terraform-google-modules/cloud-dns/google"
  version     = "3.1.0"
  project_id  = var.gcpProjectId
  type        = "private"
  name        = format("%s-restricted-gcr-%s", var.projectPrefix, var.buildSuffix)
  domain      = "gcr.io."
  description = "Override gcr.io domain to use restricted.googleapis.com"
  labels = merge(local.labels, {
    purpose = "private-google-api-access"
  })
  private_visibility_config_networks = values(local.vpcs)
  recordsets = [
    {
      name = "*"
      type = "CNAME"
      ttl  = 300
      records = [
        "restricted.googleapis.com.",
      ]
    },
  ]
}

module "artifacts" {
  count       = var.features.isolated ? 1 : 0
  source      = "terraform-google-modules/cloud-dns/google"
  version     = "3.1.0"
  project_id  = var.gcpProjectId
  type        = "private"
  name        = format("%s-restricted-artifacts-%s", var.projectPrefix, var.buildSuffix)
  domain      = "pkg.dev."
  description = "Override pkg.dev domain to use restricted.googleapis.com"
  labels = merge(local.labels, {
    purpose = "private-google-api-access"
  })
  private_visibility_config_networks = values(local.vpcs)
  recordsets = [
    {
      name = "*"
      type = "CNAME"
      ttl  = 300
      records = [
        "restricted.googleapis.com.",
      ]
    },
  ]
}
