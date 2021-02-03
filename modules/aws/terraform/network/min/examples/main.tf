provider "aws" {
  region = "us-west-2"
}
module "aws_network" {
  source                  = "../"
  project                 = "singleVpc"
  userId                  = "sasha"
  map_public_ip_on_launch = true
}
