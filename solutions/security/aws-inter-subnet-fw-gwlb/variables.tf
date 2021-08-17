resource "random_id" "buildSuffix" {
  byte_length = 2
}
variable "projectPrefix" {
  description = "projectPrefix name for tagging"
  default     = "gwlb-fw"
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
variable "adminSourceCidr" {
  description = "cidr range allowed to access the jumpHost"
  default     = "0.0.0.0/0"
}
variable "vpcMainCidr" {
  description = "cidr range for vpcMain"
  default     = "10.1.0.0/16"
}
variable "vpcMainSubPubACidr" {
  description = "cidr range for public subnetA"
  default     = "10.1.10.0/24"
}
variable "vpcMainSubPubBCidr" {
  description = "cidr range for public subnetB"
  default     = "10.1.110.0/24"
}
variable "vpcMainSubPrivACidr" {
  description = "cidr range for public subnetA"
  default     = "10.1.20.0/24"
}
variable "vpcMainSubPrivBCidr" {
  description = "cidr range for public subnetB"
  default     = "10.1.120.0/24"
}
variable "vpcMainSubGwlbeACidr" {
  description = "cidr range for GWLBE subnet A"
  default     = "10.1.52.0/24"
}
variable "vpcMainSubGwlbeBCidr" {
  description = "cidr range for GWLBE subnet B"
  default     = "10.1.152.0/24"
}
