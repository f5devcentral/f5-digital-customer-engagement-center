variable "awsVpc" {
  type = object({
    awsRegion  = string
    awsZones   = list(string)
    cidr       = string
  })
}

variable "context" {
  type = object({
    resourceOwner = string
    random        = string
  })
}