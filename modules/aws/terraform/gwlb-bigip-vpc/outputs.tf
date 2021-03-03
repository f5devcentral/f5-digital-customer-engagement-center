locals {
  vpcs = {
    "vpcGwlb" = aws_vpc.vpcGwlb.id
  }
  subnetsAz1 = {
    "vpcGwlbSubPubA" = aws_subnet.vpcGwlbSubPubA.id
  }
  subnetsAz2 = {
    "vpcGwlbSubPubB" = aws_subnet.vpcGwlbSubPubB.id
  }
}

output "vpcs" {
  value = local.vpcs
}

output "subnetsAz1" {
  value = local.subnetsAz1
}

output "subnetsAz2" {
  value = local.subnetsAz2
}
output "bigipAz1Ip" {
  value = module.bigipAz1.mgmtPublicIP
}
output "bigipPassword" {
  value = module.bigipAz1.bigip_password
}
output "gwlbEndpointService" {
  value = aws_vpc_endpoint_service.gwlbEndpointService.service_name
}
output "gwlbeAz1" {
  description = "Id of the GWLB endpoint in AZ1"
  value       = length(aws_vpc_endpoint.vpcGwlbeAz1) > 0 ? aws_vpc_endpoint.vpcGwlbeAz1[0].id : null
}
output "gwlbeAz2" {
  description = "Id of the GWLB endpoint in AZ2"
  value       = length(aws_vpc_endpoint.vpcGwlbeAz2) > 0 ? aws_vpc_endpoint.vpcGwlbeAz2[0].id : null
}
output "subnetGwlbeAz1" {
  value = length(aws_subnet.subnetGwlbeAz1) > 0 ? aws_subnet.subnetGwlbeAz1[0].id : null
}
output "subnetGwlbeAz2" {
  value = length(aws_subnet.subnetGwlbeAz2) > 0 ? aws_subnet.subnetGwlbeAz2[0].id : null
}
