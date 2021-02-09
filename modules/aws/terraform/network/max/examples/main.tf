module "vpc" {
  source  = "../"
  aws_vpc = var.aws_vpc
  context = var.context
}
