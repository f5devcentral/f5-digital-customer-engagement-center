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
data "http" "template_workspace" {
  url = var.onboardScript
}
data "template_file" "onboard" {

  template = data.http.template_workspace.body
  vars = {
    repositories = var.repositories
  }
}

# interface external
resource "aws_network_interface" "mgmt" {
  subnet_id       = var.mgmt_subnet.id
  security_groups = [var.securityGroup.id]
  tags = {
    Name = "${var.projectPrefix}workstation-interface${var.buildSuffix}"
  }
}
# public address
resource "aws_eip" "mgmt" {
  vpc               = true
  network_interface = aws_network_interface.mgmt.id
  tags = {
    Name = "${var.projectPrefix}workstation-eip${var.buildSuffix}"
  }
}
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.workstation.id
  allocation_id = aws_eip.mgmt.id
}
# instance
resource "aws_instance" "workstation" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instanceType
  key_name      = var.key_name
  #user_data_base64 = "${data.template_cloudinit_config.config.rendered}"
  user_data = data.template_file.onboard.rendered
  network_interface {
    network_interface_id = aws_network_interface.mgmt.id
    device_index         = 0
  }
  root_block_device { delete_on_termination = true }

  tags = {
    Name = "${var.projectPrefix}workstation${var.buildSuffix}"
  }
}
