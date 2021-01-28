resource "random_id" "randomString" {
  byte_length = 4
}

variable "userId" {
  default = "xadmin"
}
variable "project" {
  description = "project name for tagging"
  default     = "gwlb-fw"
}
variable "sshPublicKey" {
  description = "ssh key file to create an ec2 key-pair"
  default     = "ssh-rsa AAAAB3...."
}
variable "adminSourceCidr" {
  default = "0.0.0.0/0"
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

variable "kubernetes" {
  default     = true
  description = " deploy a kubernetes cluster or not"
}
variable "clusterName" {
  default     = "my-cluster"
  description = "eks cluster name"
}
