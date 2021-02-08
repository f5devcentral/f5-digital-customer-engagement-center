# AWS VPC Inputs
variable "aws_vpc" {
  type = object({
    cidr    = string
    azs     = list(string)
    region  = string
  })
}

# Project Tagging
variable "context" {
  type = object({
    prefix  = string
    random  = string
  })
}

# Offsets use for the calculated subnet ranges
variable "offsets" {
  type = object({
    internal = number
    external = number
    management = number
  })

  default = {
    internal = 20
    external = 0
    management = 10
  }
}