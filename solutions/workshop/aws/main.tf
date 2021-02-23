#https://learn.hashicorp.com/tutorials/terraform/for-each

provider "aws" {
  region = var.awsRegion
}
// IAM


// Network
module "aws_network" {
  for_each                = var.students
  source                  = "../../../modules/aws/terraform/network/min/"
  projectPrefix           = each.value.projectPrefix
  awsRegion               = var.awsRegion
  map_public_ip_on_launch = true
}
// keys
resource "aws_key_pair" "admin" {
  key_name   = "${var.adminAccountName}-${var.projectPrefix}"
  public_key = var.sshPublicKey
}

resource "tls_private_key" "student" {
  for_each  = var.students
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "student_key" {
  for_each   = var.students
  key_name   = "${each.key}-${each.value.projectPrefix}"
  public_key = tls_private_key.student[each.key].public_key_openssh
}

// jumphost
module "jumphost" {
  for_each             = var.students
  source               = "../../../modules/aws/terraform/workstation"
  projectPrefix        = each.value.projectPrefix
  adminAccountName     = each.key
  coderAccountPassword = random_password.password.result
  vpc                  = module.aws_network[each.key].vpcs["main"]
  keyName              = aws_key_pair.student_key[each.key].id
  mgmtSubnet           = module.aws_network[each.key].subnetsAz1["mgmt"]
  securityGroup        = aws_security_group.secGroupWorkstation[each.key].id
}
