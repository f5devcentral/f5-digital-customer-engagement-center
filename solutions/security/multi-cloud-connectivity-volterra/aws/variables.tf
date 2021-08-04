resource "random_id" "buildSuffix" {
  byte_length = 2
}
variable "projectPrefix" {
  description = "projectPrefix name for tagging"
  default     = "fw-inter-vpc"
}
variable "resourceOwner" {
  description = "Owner of the deployment for tagging purposes"
  default     = "elsa"
}
variable "awsRegion" {
  description = "aws region"
  type        = string
  default     = "us-east-2"
}
variable "sshPublicKey" {
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
  default     = null
}
variable "volterraCloudCred" {
  description = "Name of the volterra cloud credentials"
  type        = string
  default     = null
}
variable "namespace" {
  description = "Volterra application namespace"
  type        = string
  default     = "default"
}
variable "assisted" {
  description = "Use Assisted deployment for Volterra TGW Site"
  default     = false
}
variable "volterraUniquePrefix" {
  description = "Unique prefix to use for System resources in Volterra tenant"
  default     = "acme"
}

variable "volterraVirtualSite" {
  type        = string
  description = <<EOD
The name of the Volterra virtual site that will receive LB registrations.
EOD
}
