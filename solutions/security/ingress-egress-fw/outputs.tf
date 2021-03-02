output "bigipAz1Ip" {
  description = "public ip address of the BIGIP"
  value = module.gwlb-bigip-vpc.bigipAz1Ip
}
output "ubuntuJumpHostAz1" {
  description = "public ip address of the jumphost"
  value = aws_instance.ubuntuVpcMainSubnetA.public_ip
}
