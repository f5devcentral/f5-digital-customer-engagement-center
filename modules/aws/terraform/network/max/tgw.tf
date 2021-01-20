/* ## F5 Networks Secure Cloud Migration and Securty Zone Template for AWS ####################################################################################################################################################################################
Version 1.4
March 2020


This Template is provided as is and without warranty or support.  It is intended for demonstration or reference purposes. While all attempts are made to ensure it functions as desired it is not a supported by F5 Networks.  This template can be used
to quickly deploy a Security VPC - aka DMZ, in-front of the your application VPC(S).  Additional VPCs can be added to the template by adding CIDR variables, VPC resource blocks, VPC specific route tables
and TransitGateway edits. Limits to VPCs that can be added are =to the limits of transit gateway.

It is built to run in a region with three zones to use and will place services in 1a and 1c.  Modifications to other zones can be done.

F5 Application Services will be deployed into the security VPC but if one wished they could also be deployed inside of the Application VPCs.

*/
###############################################################################################################################################################################################################################################################

#### Start Transit Gateway and subcomponents  #################################################################################################################################################################################################################################
#
#  Transit Gateway is used to connect the VPCs and allows for client IP address transparency - IE "Transit" topologies.  Transit Gateway should be used unless the customer is commited to the Transit VPC topology.
#
###############################################################################################################################################################################################################################################################################

#Transit Gateway

resource "aws_ec2_transit_gateway" "security-app-tgw" {
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  description                     = "${var.project}_transit_gateway"

  tags = {
    Name = "${var.project}_security-app-tgw"
  }
}

#Create Transit Gateway Route Table

resource "aws_ec2_transit_gateway_route_table" "security-app-tgw-main-rt" {
  transit_gateway_id = aws_ec2_transit_gateway.security-app-tgw.id

  tags = {
    Name = "${var.project}_security-app-tgw-main-rt"
  }
}

# Attached the Transit Gateway to the VPCs

resource "aws_ec2_transit_gateway_vpc_attachment" "security-app-tgw-security" {
  subnet_ids                                      = [aws_subnet.sec_subnet_peering_aws_az1.id, aws_subnet.sec_subnet_peering_aws_az2.id]
  transit_gateway_id                              = aws_ec2_transit_gateway.security-app-tgw.id
  vpc_id                                          = aws_vpc.security.id
  transit_gateway_default_route_table_association = "false"
  transit_gateway_default_route_table_propagation = "false"

  tags = {
    Name = "${var.project}_security-app-tgw-security"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "security-app-tgw-app-vpc" {
  subnet_ids                                      = [aws_subnet.app_subnet_peering_aws_az1.id, aws_subnet.app_subnet_peering_aws_az2.id]
  transit_gateway_id                              = aws_ec2_transit_gateway.security-app-tgw.id
  vpc_id                                          = aws_vpc.application.id
  transit_gateway_default_route_table_association = "false"
  transit_gateway_default_route_table_propagation = "false"

  tags = {
    Name = "${var.project}_security-app-tgw-app-vpc"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "security-app-tgw-container-vpc" {
  subnet_ids                                      = [aws_subnet.container_subnet_peering_aws_az1.id, aws_subnet.container_subnet_peering_aws_az2.id]
  transit_gateway_id                              = aws_ec2_transit_gateway.security-app-tgw.id
  vpc_id                                          = aws_vpc.containers.id
  transit_gateway_default_route_table_association = "false"
  transit_gateway_default_route_table_propagation = "false"

  tags = {
    Name = "${var.project}_security-app-tgw-app-vpc"
  }
}

## Tranist Gateway Route Table Associations

resource "aws_ec2_transit_gateway_route_table_association" "security-app-tgw-security-internal" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.security-app-tgw-security.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.security-app-tgw-main-rt.id
}

resource "aws_ec2_transit_gateway_route_table_association" "security-app-tgw-app-main" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.security-app-tgw-app-vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.security-app-tgw-main-rt.id
}

resource "aws_ec2_transit_gateway_route_table_association" "security-app-tgw-container-main" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.security-app-tgw-container-vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.security-app-tgw-main-rt.id
}

#Create Transit Gateway Route Table Propegations

resource "aws_ec2_transit_gateway_route_table_propagation" "security-app-tgw-sec-prop" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.security-app-tgw-security.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.security-app-tgw-main-rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "security-app-tgw-app-prop" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.security-app-tgw-app-vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.security-app-tgw-main-rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "security-app-tgw-container-prop" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.security-app-tgw-container-vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.security-app-tgw-main-rt.id
}

## Create Transit Gateway Routes

resource "aws_ec2_transit_gateway_route" "security-app-tgw-default" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.security-app-tgw-security.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.security-app-tgw-main-rt.id
}
#Remove the Propegations above and use the Static Below if you would like more control of the routes in the TGW table.
/*
resource "aws_ec2_transit_gateway_route" "security-app-tgw-default-security-cidr" {
  destination_cidr_block         = var.cidr-1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.security-app-tgw-security.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.security-app-tgw-main-rt.id
}

resource "aws_ec2_transit_gateway_route" "security-app-tgw-default-app-cidr" {
  destination_cidr_block         = var.cidr-2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.security-app-tgw-app-vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.security-app-tgw-main-rt.id
}

resource "aws_ec2_transit_gateway_route" "security-app-tgw-default-container-cidr" {
  destination_cidr_block         = var.cidr-3
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.security-app-tgw-container-vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.security-app-tgw-main-rt.id
}
*/
#### Internal Routes from VPCS to TGW  ########################################################################################################################################################################################################################################
#
#  Transit Gateway is used to connect the VPCs and allows for client IP address transparency - IE "Transit" topologies.  Transit Gateway should be used unless the customer is commited to the Transit VPC topology.
#
###############################################################################################################################################################################################################################################################################

#Security VPC to APP VPC

resource "aws_route" "sec-vpc-routes" {
  route_table_id         = aws_route_table.sec_Internal_rt.id
  destination_cidr_block = var.cidr-2
  transit_gateway_id     = aws_ec2_transit_gateway.security-app-tgw.id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.security-app-tgw-security]
}


resource "aws_route" "sec-container-vpc-routes" {
  route_table_id         = aws_route_table.sec_Internal_rt.id
  destination_cidr_block = var.cidr-3
  transit_gateway_id     = aws_ec2_transit_gateway.security-app-tgw.id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.security-app-tgw-security]
}

resource "aws_route" "sec-vpc-nat-routes" {
  route_table_id         = aws_route_table.internet_rt.id
  destination_cidr_block = var.cidr-2
  transit_gateway_id     = aws_ec2_transit_gateway.security-app-tgw.id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.security-app-tgw-security]
}

resource "aws_route" "sec-container-vpc-nat-routes" {
  route_table_id         = aws_route_table.internet_rt.id
  destination_cidr_block = var.cidr-3
  transit_gateway_id     = aws_ec2_transit_gateway.security-app-tgw.id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.security-app-tgw-security]
}

resource "aws_route" "sec-default-routes" {
  route_table_id         = aws_route_table.internet_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route" "nat-application-default-routes_az1" {
  route_table_id         = aws_route_table.sec_application_az1_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.sec-gw-az1.id
}

resource "aws_route" "nat-application-default-routes_az2" {
  route_table_id         = aws_route_table.sec_application_az2_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.sec-gw-az2.id
}

#App VPC Default to TGW
resource "aws_route" "app-vpc-routes" {
  route_table_id         = aws_route_table.app_tgw_main_rt.id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = aws_ec2_transit_gateway.security-app-tgw.id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.security-app-tgw-app-vpc]
}

#Conatiner VPC Default to TGW
resource "aws_route" "container-vpc-routes" {
  route_table_id         = aws_route_table.container_tgw_main_rt.id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = aws_ec2_transit_gateway.security-app-tgw.id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.security-app-tgw-container-vpc]
}
