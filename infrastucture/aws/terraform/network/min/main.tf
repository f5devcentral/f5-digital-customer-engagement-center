resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name  = "vpc nginx experience"
    Nginx = "nginx experience ${var.random_id}"
  }
}

resource "aws_subnet" "management-subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.management_subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name  = "Management Subnet ${var.random_id}"
    Nginx = "nginx experience ${var.random_id}"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.aws_az1
  map_public_ip_on_launch = true

  tags = {
    Name  = "Web Public Subnet ${var.random_id}"
    Nginx = "nginx experience ${var.random_id}"
    // "kubernetes.io/role/elb" = "1"
    // "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}


resource "aws_subnet" "private-subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = var.aws_az2
  map_public_ip_on_launch = true

  tags = {
    Name  = "Web Private Subnet ${var.random_id}"
    Nginx = "nginx experience ${var.random_id}"
    // "kubernetes.io/role/internal-elb" = "1"
    // "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Nginx = "nginx experience ${var.random_id}"
    Name  = "VPC IGW ${var.random_id}"
  }
}

resource "aws_route_table" "web-public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name  = "Public Subnet RT ${var.random_id}"
    Nginx = "nginx experience ${var.random_id}"
  }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "web-public-rt" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.web-public-rt.id
}

resource "aws_route_table_association" "web-private-rt" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.web-public-rt.id
}
