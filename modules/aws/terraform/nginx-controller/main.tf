############################
# CREATE Ubuntu VM for NGINX CONTROLLER in BIG-IP VPC
############################

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

data "template_file" "controller_user_data" {
  template = file("${path.module}/templates/startup.sh.tpl")
  vars = {
    controllerInstallUrl = "https://${var.bucketId}.s3.amazonaws.com/${var.bucketFileId}"
    s3_bucket_name       = var.bucketId
    object_key           = var.bucketFileId
    secretName           = aws_secretsmanager_secret.controller_secrets.id
    region               = var.aws_region
  }
}

#Create the Controller instance
resource "aws_instance" "controller" {
  ami                         = data.aws_ami.ubuntu.id
  subnet_id                   = var.subnet
  associate_public_ip_address = true
  instance_type               = "c5.2xlarge"
  iam_instance_profile        = aws_iam_instance_profile.controller_role.name
  key_name                    = var.ec2KeyName
  user_data                   = data.template_file.controller_user_data.rendered
  vpc_security_group_ids = [
    var.securityGroup.id
  ]
  root_block_device {
    volume_size = 100
  }
  tags = {
    Name     = "${var.prefix}-controller"
    poc_name = var.prefix
  }
}
