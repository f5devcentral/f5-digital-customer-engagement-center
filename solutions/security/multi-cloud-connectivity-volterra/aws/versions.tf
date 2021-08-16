
terraform {
  required_version = ">= 0.14.5"

  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "0.8.1"
    }
    aws = ">= 3"
  }
}
