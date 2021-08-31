variable "buildSuffix" {
  type        = string
  description = "random build suffix for resources"
}
variable "projectPrefix" {
  type        = string
  description = "projectPrefix name for tagging"
}
variable "resourceOwner" {
  type        = string
  description = "Owner of the deployment for tagging purposes"
}
variable "awsRegion" {
  description = "aws region"
  type        = string
}
variable "ssh_key" {
  description = "SSH public key used to create an EC2 keypair"
  type        = string
  default     = null
}
variable "awsAz1" {
  description = "Availability zone, will dynamically choose one if left empty"
  type        = string
  default     = null
}
variable "awsAz2" {
  description = "Availability zone, will dynamically choose one if left empty"
  type        = string
  default     = null
}
variable "awsAz3" {
  description = "Availability zone, will dynamically choose one if left empty"
  type        = string
  default     = null
}
variable "volterraP12" {
  description = "Location of volterra p12 file"
  type        = string
  default     = null
}

variable "volterraUrl" {
  description = "url of volterra api"
  type        = string
  default     = null
}
variable "volterraTenant" {
  description = "Tenant of Volterra"
  type        = string
}
variable "volterraCloudCred" {
  description = "Name of the volterra cloud credentials"
  type        = string
  default     = null
}
variable "namespace" {
  description = "Volterra application namespace"
  type        = string
}

variable "volterraVirtualSite" {
  type        = string
  description = <<EOD
The name of the Volterra virtual site that will receive LB registrations.
EOD
}

variable "domain_name" {
  type        = string
  description = <<EOD
The DNS domain name that will be used as common parent generated DNS name of
loadbalancers.
EOD
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = <<EOD
An optional list of labels to apply to AWS resources.
EOD
}
