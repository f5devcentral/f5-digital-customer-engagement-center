locals {
  vpcs = {
    "main" = aws_vpc.vpcMain.id
  }
  subnetsAz1 = {
    "public"  = aws_subnet.vpcMainSubPubA.id
    "private" = aws_subnet.vpcMainSubMgmtA.id
    "mgmt"    = aws_subnet.vpcMainSubPrivA.id
  }
  subnetsAz2 = {
    "public"  = aws_subnet.vpcMainSubPubB.id
    "private" = aws_subnet.vpcMainSubMgmtB.id
    "mgmt"    = aws_subnet.vpcMainSubPrivB.id
  }
  securityGroups = {
    "bigip" = aws_security_group.secGroupVpcMainWeb.id
    "web"   = aws_security_group.secGroupVpcMainBigip.id
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

output "jumphostPublicIp" {
  value = aws_instance.jumphostVpcMain.public_ip
}

output "securityGroups" {
  description = "security groups"
  value       = local.securityGroups
}
