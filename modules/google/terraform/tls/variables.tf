# project

variable "gcpProjectId" {
  type        = string
  description = "gcp project id"
}

variable "secret_manager_key_name" {
  type        = string
  description = <<EOD
The unique key name to use for stored TLS credentials. Must be unique within the
GCP project specified by `gcpProjectId`.
EOD
}

variable "tls_cert" {
  type        = string
  default     = ""
  description = <<EOD
An optional TLS certificate, preferably a full chain, to install in Secret Manager.
If left blank (default), a self-signed cert will be generated and used. See also
`tls_key` and `ca_cert` variables.
EOD
}

variable "tls_key" {
  type        = string
  default     = ""
  description = <<EOD
An optional TLS private key to install in Secret Manager. If left blank (default),
a self-signed cert will be generated and used. See also `tls_cert` and `ca_cert`
variables.
EOD
}

variable "ca_cert" {
  type        = string
  default     = ""
  description = <<EOD
An optional CA certificate to install in Secret Manager, if TLS cert and key pair
are provided. Ignored if a self-signed TLS cert is generated because either of
`tls_cert` or `tls_key` are missing.
EOD
}

variable "domain_name" {
  type        = string
  default     = ""
  description = <<EOD
An optional DNS domain name to add to a generated TLS certificate with wildcard.
Ignored if `tls_cert` and `tls_key` are provided.

E.g. if domain_name = "example.com", the generated TLS certificate will include
SANs for 'example.com' and '*.example.com', in addition to defaults.
EOD
}

variable "secret_accessors" {
  type        = list(string)
  default     = []
  description = <<EOD
An optional list of users, groups, and/or service accounts that will be granted
access to the TLS secret value.

E.g. to allow service account foo@bar.iam.gserviceaccount.com to read the secret
secret_accessors = [
  "serviceAccount:foo@bar.iam.gserviceaccount.com",
]
EOD
}
