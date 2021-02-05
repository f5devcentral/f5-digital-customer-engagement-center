output "gwlbEndpointService" {
  value = module.gwlb-bigip-vpc.gwlbEndpointService
}

output "vpc_id" {
  value = module.gwlb-bigip-vpc.vpcs["vpcGwlb"]
}
