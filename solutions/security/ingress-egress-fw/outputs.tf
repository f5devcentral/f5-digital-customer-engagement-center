output "bigipPublicIp" {
  description = "Public ip for the BIGIP, access on port 8443"
  value       = module.gwlb-bigip-vpc.bigipIp
}
output "ubuntuJumpHostAz1" {
  description = "public ip address of the jumphost"
  value       = aws_instance.ubuntuVpcMainSubnetA.public_ip
}
output "bigipPassword" {
  description = "Password for the admin usernmae"
  value       = module.gwlb-bigip-vpc.bigipPassword
}
