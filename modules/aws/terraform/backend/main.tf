# AMI

locals {
  user_data = coalesce(var.user_data, templatefile("${path.module}/templates/cloud-config.yml", {
    f5_logo_rgb_svg = base64gzip(file("${path.module}/files/f5-logo-rgb.svg"))
    styles_css      = base64gzip(file("${path.module}/files/styles.css"))
  }))
}

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
  user_data     = local.user_data
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
