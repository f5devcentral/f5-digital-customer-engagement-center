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

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
output "geneveProxyIp" {
  value = aws_instance.GeneveProxy.public_ip
}
output "gwlbEndpointService" {
  value = aws_vpc_endpoint_service.gwlbEndpointService.service_name
}
