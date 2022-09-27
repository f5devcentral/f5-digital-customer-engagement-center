# AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

#security group

# bash script template
locals {
  onboard = templatefile("${path.module}/templates/startup.sh.tpl", {
    repositories         = var.repositories
    coderAccountPassword = var.coderAccountPassword
    terraformVersion     = var.terraformVersion
  })
}


# interface external
resource "aws_network_interface" "mgmtNic" {
  subnet_id       = var.mgmtSubnet
  security_groups = [var.securityGroup]
  tags = {
    Name  = "${var.projectPrefix}-workstation-interface"
    Owner = var.resourceOwner
  }
}
# public address
resource "aws_eip" "mgmtEip" {
  count             = var.associateEIP ? 1 : 0
  vpc               = true
  network_interface = aws_network_interface.mgmtNic.id
  tags = {
    Name  = "${var.projectPrefix}-workstation-eip"
    Owner = var.resourceOwner
  }
  depends_on = [aws_network_interface.mgmtNic]
}

# instance
resource "aws_instance" "workstation" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instanceType
  key_name      = var.keyName
  user_data     = local.onboard
  network_interface {
    network_interface_id = aws_network_interface.mgmtNic.id
    device_index         = 0
  }
  root_block_device { delete_on_termination = true }

  tags = {
    Name  = "${var.projectPrefix}-workstation"
    Owner = var.resourceOwner
  }
}
