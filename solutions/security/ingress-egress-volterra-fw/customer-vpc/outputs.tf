
output "ubuntuJumpHostAz1" {
  description = "public ip address of the jumphost"
  value       = aws_instance.ubuntuVpcMainSubnetA.public_ip
}
output "awsVpc" {
  description = "VPC ID"
  value       = aws_vpc.vpcMain.id
}
output "gwlbeSubnetA" {
  description = "subnet ID"
  value       = aws_subnet.vpcMainSubGwlbeA.id
}