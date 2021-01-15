variable "project" {
  description = "project name to use for tags"
  default     = "f5-dcec"
}
variable "userId" {
  description = "owner of the deployment, for tagging purposes"
  default     = "f5-dcec"
}
variable "awsAz1" {
  default = "us-east-1a"
}
variable "awsRegion" {
  default = "us-east-1"
}
variable "awsAz2" {
  default = "us-east-1b"
}
variable "sshPublicKey" {
  default = "ssh-rsa AAAAB3Nza..."
}

variable "jumphostInstanceType" {
  default = "t3.large"
}
