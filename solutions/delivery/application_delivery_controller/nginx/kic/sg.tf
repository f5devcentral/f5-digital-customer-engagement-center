resource "aws_security_group" "web" {
  name        = "sg_web_${random_id.random-string.dec}"
  description = "Allow traffic from public subnet"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.aws.vpcs["main"]

  tags = {
    Name  = "nginx Security Group ${random_id.random-string.dec}"
    Nginx = "nginx experience ${random_id.random-string.dec}"
  }
}
