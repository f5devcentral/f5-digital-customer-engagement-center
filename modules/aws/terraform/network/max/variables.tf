# AWS VPC Inputs
variable "awsVpc" {
  type = object({
    cidr      = string
    awsZones  = list(string)
    awsRegion = string
  })
}

# Project Tagging
variable "context" {
  type = object({
    resourceOwner = string
    random        = string
  })
}

# Offsets use for the calculated subnet ranges
variable "offsets" {
  type = object({
    internal   = number
    external   = number
    management = number
  })

  default = {
    internal   = 20
    external   = 0
    management = 10
  }
}