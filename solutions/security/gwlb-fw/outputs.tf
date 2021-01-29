output "geneveProxyIp" {
  value = module.gwlb-bigip-vpc.geneveProxyIp
}
output "ubuntuVpcMainSubnetA" {
  value = aws_instance.ubuntuVpcMainSubnetA.public_ip
}
