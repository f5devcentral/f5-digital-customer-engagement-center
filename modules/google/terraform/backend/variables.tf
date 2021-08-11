# project
variable "projectPrefix" {
  type        = string
  description = "prefix for resources"
  default     = "demo"
}
variable "buildSuffix" {
  type        = string
  description = "random build suffix for resources"
}
variable "gcpProjectId" {
  type        = string
  description = "gcp project id"
}
variable "resourceOwner" {
  description = "owner of the deployment, for tagging purposes"
  default     = "f5-dcec"
}

variable "name" {
  type        = string
  default     = null
  description = <<EOD
The name to assign to the server VM. If left empty(default), a name will be
generated as '{projectPrefix}-server-{buildSuffix}' where {projectPrefix}
and {buildSuffix} will be the values of the respective variables.
EOD
}

variable "service_account" {
  type        = string
  default     = null
  description = <<EOD
The service account to use with server. If empty (default), the Default Compute
service account will be used.
EOD
}

variable "image" {
  type        = string
  default     = null
  description = <<EOD
An optional Google Compute Engine image to use instead of the module default (COS).
Set this to use a specific image; see also `user_data` to set cloud-config.
EOD
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = <<EOD
An optional map of key:value strings that will be applied to resources as labels,
where supported.
EOD
}

variable "tags" {
  type        = list(string)
  default     = []
  description = <<EOD
An optional list of network tags to apply to the instance; default is an empty set.
EOD
}

variable "machine_type" {
  type        = string
  default     = "e2-standard-4"
  description = <<EOD
The compute machine type to use for workstation VM. Default is 'e2-standard-4'
which provides 4 vCPUs and 16Gb RAM, and is available in all regions.
EOD
}

variable "preemptible" {
  type        = string
  default     = false
  description = <<EOD
If set to true, the workstation will be deployed on preemptible VMs which
could be terminated at any time, and have a maximum lifetime of 24 hours. Default
value is false.
EOD
}

variable "disk_type" {
  type        = string
  default     = "pd-balanced"
  description = <<EOD
The boot disk type to use with instances; can be 'pd-balanced' (default),
'pd-ssd', or 'pd-standard'.
EOD
}

variable "disk_size_gb" {
  type        = number
  default     = 50
  description = <<EOD
Use this flag to set the boot volume size in GB. Default is 50Gb.
EOD
}

variable "subnet" {
  type        = string
  description = <<EOD
Self-link of the subnet that the workstation should be attached to.
EOD
}

variable "zone" {
  type        = string
  default     = ""
  description = <<EOD
The Compute Zone where the server will be deployed. If empty (default), instances
will be randomly assigned from zones in the subnet region.
EOD
}

variable "public_address" {
  type        = bool
  default     = false
  description = <<EOD
If true, an ephemeral public IP address will be assigned to the webserver.
Default value is 'false'.
EOD
}

variable "user_data" {
  type        = string
  default     = null
  description = <<EOD
An optional cloud-config definition to apply to the launched instances. If empty
(default), a simple webserver will be launched that displays the hostname of the
instance that serviced the request.
EOD
}

variable "tls_secret_key" {
  type        = string
  default     = ""
  description = <<EOD
An optional Secret Manager key that contains a TLS certificate and key pair that
will be used for the backend server. If empty (default), the backend server will
listen on port 80 only unless a custom `user_data` is provided.
EOD
}
