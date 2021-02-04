output "subnets" {
  value = [module.aws_network.subnetsAz2["public"], module.aws_network.subnetsAz1["public"]]
}

output "vpc_id" {
  value = module.aws_network.vpcs["main"]
}
