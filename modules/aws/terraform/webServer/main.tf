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


#ata "template_cloudinit_config" "applicationServer" {
# gzip          = true
# base64_encode = true
#
# # Main cloud-config configuration file.
# part {
#   filename     = "init.cfg"
#   content_type = "text/cloud-config"
#   content      = file("${path.module}/templates/cloud-config-base.yaml")
# }
# part {
#   content_type = "text/x-shellscript"
#   content      = file(var.startupScriptPath)
# }
#}

data "template_file" "applicationServer" {
  template = file("${path.module}/templates/cloud-config-base.yaml")

  vars = {
    startupCommand = var.startupCommand
  }
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
}

# instance
resource "aws_instance" "workstation" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instanceType
  key_name      = var.keyName
  user_data     = data.template_file.applicationServer.rendered
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
