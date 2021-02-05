output "bigipAz1Ip" {
  value = module.gwlb-bigip-vpc.bigipAz1Ip
}
#output "geneveProxyAz2Ip" {
#  value = module.gwlb-bigip-vpc.geneveProxyAz2Ip
#}
output "ubuntuJumpHostAz1" {
  value = aws_instance.ubuntuVpcMainSubnetA.public_ip
}
