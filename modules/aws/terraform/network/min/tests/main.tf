provider "aws" {
  region = var.awsRegion
}
module "aws_network" {
  source                  = "../"
  projectPrefix           = var.projectPrefix
  buildSuffix             = random_id.buildSuffix.hex
  resourceOwner           = var.resourceOwner
  map_public_ip_on_launch = true
}
