resource "aws_subnet" "management-subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.management_subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name  = "Management Subnet ${random_id.random-string.dec}"
    Nginx = "nginx experience ${random_id.random-string.dec}"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.aws_az
  map_public_ip_on_launch = true

  tags = {
    Name                     = "Web Public Subnet ${random_id.random-string.dec}"
    Nginx                    = "nginx experience ${random_id.random-string.dec}"
    "kubernetes.io/role/elb" = "1"
  }
}


resource "aws_subnet" "private-subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.aws_az1

  tags = {
    Name                              = "Web Private Subnet ${random_id.random-string.dec}"
    Nginx                             = "nginx experience ${random_id.random-string.dec}"
    "kubernetes.io/role/internal-elb" = "1"
  }
}
