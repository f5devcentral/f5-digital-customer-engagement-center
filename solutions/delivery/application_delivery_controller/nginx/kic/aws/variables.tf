resource "random_id" "randomString" {
  byte_length = 4
}

variable "userId" {
  default = "xadmin"
}
variable "sshPublicKey" {
  description = "ssh key file to create an ec2 key-pair"
  default     = "ssh-rsa AAAAB3...."
}
variable "adminSourceCidr" {
  default = "0.0.0.0/0"
}
variable "awsRegion" {
  default = "eu-central-1"
}

variable "awsAz1" {
  default = "eu-central-1a"
}

variable "awsAz2" {
  default = "eu-central-1b"
}

variable "kubernetes" {
  default     = true
  description = " deploy a kubernetes cluster or not"
}
variable "clusterName" {
  default     = "my-cluster"
  description = "eks cluster name"
}
