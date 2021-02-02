variable "project" {
  description = "project name to use for tags"
  default     = "f5-dcec"
}
variable "userId" {
  description = "owner of the deployment, for tagging purposes"
  default     = "f5-user"
}
variable "awsAz1" {
  default = null
}
variable "awsAz2" {
  default = null
}
variable "awsRegion" {
  default = "us-east-1"
}
variable "map_public_ip_on_launch" {
  description = "assigns public ip's to instances in the public subnet by default"
  default     = false
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
variable "vpcMainSubMgmtACidr" {
  default = "10.1.1.0/24"
}
variable "vpcMainSubMgmtBCidr" {
  default = "10.1.101.0/24"
}
variable "vpcMainSubPrivACidr" {
  default = "10.1.20.0/24"
}
variable "vpcMainSubPrivBCidr" {
  default = "10.1.120.0/24"
}
