resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name  = "vpc nginx experience"
    Nginx = "nginx experience ${random_id.random-string.dec}"
  }
}

resource "aws_subnet" "management-subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.management_subnet_cidr
  availability_zone       = var.aws_az
  map_public_ip_on_launch = true
  tags = {
    Name  = "Management Subnet"
    Nginx = "nginx experience ${random_id.random-string.dec}"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.aws_az
  map_public_ip_on_launch = true

  tags = {
    Name                                                                       = "Web Public Subnet"
    Nginx                                                                      = "nginx experience ${random_id.random-string.dec}"
    "kubernetes.io/role/elb"                                                   = "1"
    "kubernetes.io/cluster/${var.cluster-name}-${random_id.random-string.dec}" = "shared"
  }
}

# Define the private subnet
resource "aws_subnet" "private-subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = var.aws_az1
  map_public_ip_on_launch = true

  tags = {
    Name                                                                       = "Web Private Subnet"
    Nginx                                                                      = "nginx experience ${random_id.random-string.dec}"
    "kubernetes.io/role/internal-elb"                                          = "1"
    "kubernetes.io/cluster/${var.cluster-name}-${random_id.random-string.dec}" = "shared"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Nginx = "nginx experience ${random_id.random-string.dec}"
    Name  = "VPC IGW"
  }
}

resource "aws_route_table" "web-public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name  = "Public Subnet RT"
    Nginx = "nginx experience ${random_id.random-string.dec}"
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

resource "aws_security_group" "sgweb" {
  name        = "sg_test_web"
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

  vpc_id = aws_vpc.main.id

  tags = {
    Name  = "Sorin Security Group"
    Nginx = "nginx experience ${random_id.random-string.dec}"
  }
}

resource "aws_key_pair" "main" {
  key_name   = "kp${var.key_name}-${random_id.random-string.dec}"
  public_key = file(var.key_path)
}
