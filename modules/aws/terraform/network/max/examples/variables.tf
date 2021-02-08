variable "aws_vpc" {
  type = object({
    region  = string
    azs     = list(string)
    cidr    = string
  })
}

variable "context" {
  type = object({
    prefix      = string
    random      = string
  })
}