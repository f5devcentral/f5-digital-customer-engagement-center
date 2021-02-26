resource "random_id" "buildSuffix" {
  byte_length = 2
}
variable "projectPrefix" {
  description = "projectPrefix name for tagging"
  default     = "fw-inter-vpc"
}
variable "resourceOwner" {
  default = "elsa"
}
variable "awsRegion" {
  default = "us-east-2"
}
variable "sshPublicKey" {
  default = null
}
variable "awsAz1" {
  default = null
}
variable "awsAz2" {
  default = null
}
