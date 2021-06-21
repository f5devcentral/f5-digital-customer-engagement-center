variable "projectPrefix" {
  description = "projectPrefix name to use for tags"
  default     = "f5-dcec"
}
variable "resourceOwner" {
  description = "owner of the deployment, for tagging purposes"
  default     = "f5-dcec"
}
variable "buildSuffix" {
  description = "random build suffix for tagging"
  default     = "f5-dcec"
}
variable "awsAz1" {
  description = "will use a dynamic az if left empty"
  default     = null
}
variable "awsAz2" {
  description = "will use a dynamic az if left empty"
  default     = null
}
variable "keyName" {
  default = null
}
variable "allowedMgmtIps" {
  default = ["0.0.0.0/0"]
}
variable "vpcCidr" {
  default = "10.252.0.0/16"
}
variable "vpcGwlbSubPubACidr" {
  default = "10.252.10.0/24"
}
variable "vpcGwlbSubPubBCidr" {
  default = "10.252.110.0/24"
}
variable "subnetGwlbeAz1" {
  default = "10.252.54.0/24"
}
variable "subnetGwlbeAz2" {
  default = "10.252.154.0/24"
}
variable "createGwlbEndpoint" {
  default     = false
  type        = bool
  description = "Controls the creation of gwlb endpoints in the provided vpc, if true creates subnets and endpoints"
}
variable "bigipInstanceCount" {
  default     = 2
  type        = number
  description = "number of BIGIP devices to deploy"
}
variable "customUserData" {
  description = "content of a file containing custom user data for the BIGIP instance"
  default     = null
}