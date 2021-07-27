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
variable "gcpRegion" {
  type        = string
  description = "region where resources will be deployed"
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
  default     = ""
  description = <<EOD
The name to assign to the workstation VM. If left empty(default), a name will be
generated as '{projectPrefix}-workstation-{buildSuffix}' where {projectPrefix}
and {buildSuffix} will be the values of the respective variables.
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
The Compute Zone where the workstation instance will be launched. If left blank
(default), a zone in the subnet region will be chosen at random.
EOD
}

variable "users" {
  type        = list(string)
  default     = []
  description = <<EOD
An optional list of user email addresses to grant IAP access to the workstation.
Default is an empty list.
EOD
}

variable "tls_secret_key" {
  type        = string
  default     = ""
  description = <<EOD
An optional Secret Manager key that contains a TLS certificate, key, and
optionally, CA, that be used for the backend server. If left blank (default), a
self-signed cert will be generated and used.
EOD
}

variable "terraform_version" {
  type        = string
  default     = "0.14.11"
  description = <<EOD
The version of Terraform to install in the workstation. Default is 0.14.11.
EOD
}

variable "code_server_version" {
  type        = string
  default     = "3.11.0"
  description = <<EOD
The version of code-server to install in the workstation. Default is 3.11.0.
EOD
}

variable "code_server_extension_urls" {
  type = list(string)
  default = [
    "https://api.github.com/repos/f5devcentral/vscode-f5/releases/latest",
    "https://open-vsx.org/api/hashicorp/terraform/2.10.0/file/hashicorp.terraform-2.13.2.vsix",
  ]
  description = <<EOD
A list of vsix extensions to install as part of code-server initialisation.
Default list installs the latest VSCode-F5 extension from F5 DevCentral GitHub
(which may be a beta), and Terraform extension 2.10.0 from open-vsx.org.
EOD
}

variable "git_repos" {
  type = list(string)
  default = [
    "https://github.com/F5DevCentral/f5-digital-customer-engagement-center",
  ]
  description = <<EOD
An optional list of git URLs to clone into a user's home directory on workstation.
Default list will clone F5 DCEC repo.
EOD
}

variable "public_address" {
  type        = bool
  default     = false
  description = <<EOD
Set to true to assign an emphemeral IP address to the workstation instance.
Default value is 'false'. Setting value to true is required if the workstation
is on a VPC network without a NAT gateway.
EOD
}
