#
# Create the VPC 
# using directions from https://clouddocs.f5.com/cloud/public/v1/aws/AWS_multiNIC.html
#
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = format("%s-vpc-%s", var.context.prefix, var.context.random)
  cidr                 = var.aws_vpc.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  # vpc public subnet used for external interface
  public_subnets = [for num in range(length(var.aws_vpc.azs)) :
    cidrsubnet(var.aws_vpc.cidr, 8, num + var.offsets.external)
  ]

  # vpc private subnet used for internal 
  private_subnets = [
    for num in range(length(var.aws_vpc.azs)) :
    cidrsubnet(var.aws_vpc.cidr, 8, num + var.offsets.internal)
  ]

  enable_nat_gateway = true

  # using the database subnet method since it allows a public route
  database_subnets = [
    for num in range(length(var.aws_vpc.azs)) :
    cidrsubnet(var.aws_vpc.cidr, 8, num + var.offsets.management)
  ]
  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = true

  tags = {
    Name        = format("%s-vpc-%s", var.context.prefix, var.context.random)
    Terraform   = "true"
  }
}