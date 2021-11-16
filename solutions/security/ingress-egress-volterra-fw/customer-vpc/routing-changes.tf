resource "aws_route_table" "vpcMainRtb" {
  vpc_id = aws_vpc.vpcMain.id

  route {
    cidr_block      = "0.0.0.0/0"
    vpc_endpoint_id = var.vpcEndpointId
#    vpc_endpoint_id = aws_vpc_endpoint.vpcMainGwlbeA.id
  }
  tags = {
    Name  = "${var.projectPrefix}-vpcMainRtb-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}
resource "aws_route_table" "vpcMainIgwRtb" {
  vpc_id = aws_vpc.vpcMain.id

  route {
    cidr_block      = var.vpcMainSubPubACidr
    vpc_endpoint_id = var.vpcEndpointId
    #vpc_endpoint_id = aws_vpc_endpoint.vpcMainGwlbeA.id
  }

  route {
    cidr_block      = var.vpcMainSubPubBCidr
    vpc_endpoint_id = var.vpcEndpointId
    #vpc_endpoint_id = aws_vpc_endpoint.vpcMainGwlbeB.id
  }

  tags = {
    Name  = "${var.projectPrefix}-vpcMainIgwRtb-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}


resource "aws_main_route_table_association" "vpcMainRtbAssociation" {
  vpc_id         = aws_vpc.vpcMain.id
  route_table_id = aws_route_table.vpcMainRtb.id
}
resource "aws_route_table_association" "vpcMainIgwRtbAssociation" {
  gateway_id     = aws_internet_gateway.vpcMainIgw.id
  route_table_id = aws_route_table.vpcMainIgwRtb.id
}