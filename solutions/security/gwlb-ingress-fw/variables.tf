resource "random_id" "buildSuffix" {
  byte_length = 2
}
variable "projectPrefix" {
  description = "projectPrefix name for tagging"
  default     = "gwlb-fw"
}
variable "resourceOwner" {
  default = "elsa"
}
variable "sshPublicKey" {
  description = "ssh key file to create an ec2 key-pair"
  default     = "ssh-rsa AAAAB3...."
}
variable "adminSourceCidr" {
  description = "cidr range allowed to access the jumpHost"
  default     = "0.0.0.0/0"
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
variable "vpcMainCidr" {
  default = "10.1.0.0/16"
}
variable "vpcMainSubPubACidr" {
  default = "10.1.10.0/24"
}
variable "vpcMainSubPubBCidr" {
  default = "10.1.110.0/24"
}
variable "vpcMainSubGwlbeACidr" {
  default = "10.1.52.0/24"
}
variable "vpcMainSubGwlbeBCidr" {
  default = "10.1.152.0/24"
}
