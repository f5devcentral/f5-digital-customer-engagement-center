
variable "awsRegion" {
  default = "us-west-2"
}

variable "projectPrefix" {
  default = "gwlbBigipExample"
}

variable "resourceOwner" {
  default = "elsa"
}

resource "random_id" "buildSuffix" {
  byte_length = 2
}

variable "sshPublicKey" {
  description = "ssh public key material to create an EC2 key pair"
  default     = null
}
