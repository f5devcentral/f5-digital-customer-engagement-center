locals {
  vpcs = {
    "main" = aws_vpc.main.id
  }
  subnets = {
    "public"  = aws_subnet.public-subnet.id
    "private" = aws_subnet.private-subnet.id
  }
}

output "vpcs" {
  value = local.vpcs
}

output "subnets" {
  value = local.subnets
}
