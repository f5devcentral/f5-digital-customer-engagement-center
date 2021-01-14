data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}


data "template_file" "nginx_user_data" {
  template = file("${path.module}/templates/startup.sh.tpl")
  vars = {
    controllerAddress = var.controllerAddress
    region            = var.aws_region
    secretName        = aws_secretsmanager_secret.nginx_secrets.id
  }
}

#Create the nginx instance
resource "aws_instance" "nginx" {
  ami                         = data.aws_ami.ubuntu.id
  subnet_id                   = var.subnet
  associate_public_ip_address = true
  instance_type               = var.nginxInstanceType
  iam_instance_profile        = aws_iam_instance_profile.nginx_role.name
  key_name                    = var.ec2KeyName
  user_data                   = data.template_file.nginx_user_data.rendered
  vpc_security_group_ids = [
    var.securityGroup.id
  ]
  root_block_device {
    volume_size = 100
  }
  tags = {
    Name    = "nginx_${random_id.id.hex}"
    project = var.prefix
  }
}
