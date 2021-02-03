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

# bash script template
data "template_file" "onboard" {
  template = file("${path.module}/templates/startup.sh.tpl")
  vars = {
    repositories         = var.repositories
    coderAccountPassword = var.coderAccountPassword
    terraformVersion     = var.terraformVersion
  }
}

# interface external
resource "aws_network_interface" "mgmtNic" {
  subnet_id       = var.mgmtSubnet
  security_groups = [var.securityGroup]
  tags = {
    Name  = "${var.project}-workstation-interface"
    Owner = var.userId
  }
}
# public address
resource "aws_eip" "mgmtEip" {
  vpc               = true
  network_interface = aws_network_interface.mgmtNic.id
  tags = {
    Name  = "${var.project}-workstation-eip"
    Owner = var.userId
  }
}
resource "aws_eip_association" "mgmtEipAssoc" {
  instance_id   = aws_instance.workstation.id
  allocation_id = aws_eip.mgmtEip.id
}


# instance
resource "aws_instance" "workstation" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instanceType
  key_name      = var.keyName
  #user_data_base64 = "${data.template_cloudinit_config.config.rendered}"
  user_data = data.template_file.onboard.rendered
  network_interface {
    network_interface_id = aws_network_interface.mgmtNic.id
    device_index         = 0
  }
  root_block_device { delete_on_termination = true }

  tags = {
    Name  = "${var.project}-workstation"
    Owner = var.userId
  }
}
