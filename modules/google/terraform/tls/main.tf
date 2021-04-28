terraform {
  required_version = "~> 0.14.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.54"
    }
  }
}

locals {
  generate_tls = var.tls_cert == null || length(var.tls_cert) < 1 || var.tls_key == null || length(var.tls_key) < 1
  tls_cert     = coalesce(join("", tls_locally_signed_cert.tls.*.cert_pem, tls_self_signed_cert.ca.*.cert_pem), var.tls_cert)
  tls_key      = coalesce(join("", tls_private_key.tls.*.private_key_pem), var.tls_key)
  ca_cert      = coalesce(join("", tls_self_signed_cert.ca.*.cert_pem), var.ca_cert)
  tls_secret = merge(
    {
      cert = local.tls_cert,
      key  = local.tls_key,
    },
    local.ca_cert != "" ? { ca = local.ca_cert } : {},
  )
  generated_dns_names = compact(concat(
    var.domain_name != "" ? [format("*.%s", var.domain_name), var.domain_name] : [],
    [
      format("*.c.%s.internal", var.gcpProjectId),
      "localhost",
      "localhost.localdomain",
    ]
  ))
}

# Store the TLS certificate, key, and CA in Secret Manager.
module "tls_secret" {
  source     = "memes/secret-manager/google"
  version    = "1.0.2"
  project_id = var.gcpProjectId
  id         = var.secret_manager_key_name
  secret     = jsonencode(local.tls_secret)
  accessors  = var.secret_accessors
}

# Generate a CA key, if needed
resource "tls_private_key" "ca" {
  count     = local.generate_tls ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = "2048"
}

# Generate a CA cert. if needed
resource "tls_self_signed_cert" "ca" {
  count           = local.generate_tls ? 1 : 0
  key_algorithm   = tls_private_key.ca.0.algorithm
  private_key_pem = tls_private_key.ca.0.private_key_pem
  subject {
    common_name         = format("CA (%s)", var.secret_manager_key_name)
    organization        = "F5 Networks, Inc"
    organizational_unit = "F5 DevCentral"
    locality            = "Seattle"
    province            = "Washington"
    country             = "United States"
  }
  validity_period_hours = 720
  early_renewal_hours   = 2
  is_ca_certificate     = true
  allowed_uses          = []
}

# Generate a TLS cert key, if needed
resource "tls_private_key" "tls" {
  count     = local.generate_tls ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = "2048"
}

# Generate a wildcard TLS csr for the domain, if needed
resource "tls_cert_request" "tls" {
  count           = local.generate_tls ? 1 : 0
  key_algorithm   = tls_private_key.tls.0.algorithm
  private_key_pem = tls_private_key.tls.0.private_key_pem
  subject {
    common_name         = format("TLS cert for %s", var.secret_manager_key_name)
    organization        = "F5 Networks, Inc"
    organizational_unit = "F5 DevCentral"
    locality            = "Seattle"
    province            = "Washington"
    country             = "United States"
  }
  dns_names = local.generated_dns_names
}

# Generate the TLS cert for the domain
resource "tls_locally_signed_cert" "tls" {
  count                 = local.generate_tls ? 1 : 0
  cert_request_pem      = tls_cert_request.tls.0.cert_request_pem
  ca_key_algorithm      = tls_private_key.ca.0.algorithm
  ca_private_key_pem    = tls_private_key.ca.0.private_key_pem
  ca_cert_pem           = tls_self_signed_cert.ca.0.cert_pem
  validity_period_hours = 720
  early_renewal_hours   = 2
  is_ca_certificate     = false
  allowed_uses = [
    "cert_signing",
    "key_encipherment",
    "client_auth",
    "server_auth",
  ]
}
