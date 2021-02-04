output "geneveProxyAz1Ip" {
  value = module.gwlb-bigip-vpc.geneveProxyAz1Ip
}
output "geneveProxyAz2Ip" {
  value = module.gwlb-bigip-vpc.geneveProxyAz2Ip
}
output "ubuntuJumpHostAz1" {
  value = aws_instance.ubuntuVpcMainSubnetA.public_ip
}
