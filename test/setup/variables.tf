# Common variables
variable "resourceOwner" {
  type        = string
  default     = "anonymous-kitchen-user"
  description = "Who's running this test?"
}

# AWS specific variables

# Azure specific variables

# GCP specific variables
variable "gcpProjectId" {
  type        = string
  description = "gcp project id"
}
