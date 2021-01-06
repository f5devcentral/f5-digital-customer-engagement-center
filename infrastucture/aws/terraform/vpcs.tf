resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name  = "vpc nginx experience"
    Nginx = "nginx experience ${random_id.random-string.dec}"
  }
}
