
variable "awsRegion" {
  default = "us-west-2"
}

variable "projectPrefix" {
  default = "singleVpcWorkstation"
}

variable "resourceOwner" {
  default = "elsa"
}

variable "sshPublicKey" {
  description = "ssh key file to create an ec2 key-pair"
  default     = "ssh-rsa AAAAB3...."
}

resource "random_id" "buildSuffix" {
  byte_length = 2
}
