
variable "awsRegion" {
  default = "us-west-2"
}

variable "projectPrefix" {
  default = "singleVpcExample"
}

variable "resourceOwner" {
  default = "elsa"
}

resource "random_id" "buildSuffix" {
  byte_length = 2
}
