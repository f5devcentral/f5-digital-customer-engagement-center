#output "bigipPublicIp" {
#  description = "Public ip for the BIGIP, access on port 8443"
#  value       = module.gwlb-bigip-vpc.bigipIp
#}
#output "ubuntuJumpHostAz1" {
#  description = "public ip address of the jumphost"
#  value       = aws_instance.ubuntuVpcMainSubnetA.public_ip
#}
#output "bigipPassword" {
#  description = "Password for the admin usernmae"
#  value       = module.gwlb-bigip-vpc.bigipPassword
#}
output "bigipPassword" {
  value = module.bigip[*].bigip_instance_ids[0]
}
output "gwlbEndpointService" {
  value = aws_vpc_endpoint_service.gwlbEndpointService.service_name
}
output "bigipIp" {
  value = module.bigip[*].mgmtPublicIP[0]
}