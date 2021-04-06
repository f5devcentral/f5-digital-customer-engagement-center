variable "name" {}
variable "awsRegion" {}
variable "domainName" {
  description = "cognito domain"
  type        = string
  default     = null
}