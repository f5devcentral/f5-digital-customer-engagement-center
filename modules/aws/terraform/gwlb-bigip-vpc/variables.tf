variable "project" {
  description = "project name to use for tags"
  default     = "f5-dcec"
}
variable "userId" {
  description = "owner of the deployment, for tagging purposes"
  default     = "f5-dcec"
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
variable "keyName" {
  default = null
}
variable "allowedMgmtIps" {
  default = ["0.0.0.0/0"]
}
variable "instanceCount" {
  default = 1
}
