#security group
resource "aws_security_group" "secGroupWorkstation" {
  for_each    = var.students
  name        = "${each.value.projectPrefix}-secGroupWorkstation"
  description = "Jumphost workstation security group"
  vpc_id      = module.aws_network[each.key].vpcs["main"]

  ingress {
    # ssh
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # coder https
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # coder http
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # vnc
    from_port   = 5800
    to_port     = 5800
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "${each.value.projectPrefix}-secGroupWorkstation"
    Owner = each.value.resourceOwner
  }
}
