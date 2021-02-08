# vars
resource "random_id" "randomString" {
  byte_length = 4
}
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}
# cloud
variable "projectPrefix" {
  default = "kic-aws"
}
variable "awsRegion" {
  default = "us-east-2"
}

variable "awsAz1" {
  default = null
}

variable "awsAz2" {
  default = null
}
# admin
variable "adminAccountName" {
  default = "xadmin"
}
variable "sshPublicKey" {
  description = "ssh key file to create an ec2 key-pair"
  default     = "ssh-rsa AAAAB3...."
}
variable "adminSourceCidr" {
  default = "0.0.0.0/0"
}
variable "resourceOwner" {
  description = "tag used to mark instance owner"
  default     = "dcec-kic-user"
}
# eks
variable "kubernetes" {
  default     = true
  description = " deploy a kubernetes cluster or not"
}
variable "clusterName" {
  default     = "my-cluster"
  description = "eks cluster name"
}
