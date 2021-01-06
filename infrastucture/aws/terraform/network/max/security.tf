/* ## F5 Networks Secure Cloud Migration and Securty Zone Template for AWS ####################################################################################################################################################################################
Version 1.4
March 2020


This Template is provided as is and without warranty or support.  It is intended for demonstration or reference purposes. While all attempts are made to ensure it functions as desired it is not a supported by F5 Networks.  This template can be used
to quickly deploy a Security VPC - aka DMZ, in-front of the your application VPC(S).  Additional VPCs can be added to the template by adding CIDR variables, VPC resource blocks, VPC specific route tables
and TransitGateway edits. Limits to VPCs that can be added are =to the limits of transit gateway.

It is built to run in a region with three zones to use and will place services in 1a and 1c.  Modifications to other zones can be done.

F5 Application Services will be deployed into the security VPC but if one wished they could also be deployed inside of the Application VPCs.

*/
#### Start VPC Creation #######################################################################################################################################################################################################################################
#
# Additional VPCs can be added by adding a new CIDR
# All subnets are /24.  To understand the calculation see - https://www.terraform.io/docs/configuration-0-11/interpolation.html#cidrsubnet-iprange-newbits-netnum-
#
###############################################################################################################################################################################################################################################################

################################################################################################################################################################################################################################################################
#
#  Security VPC Creation
#
################################################################################################################################################################################################################################################################

resource "aws_vpc" "security" {
  cidr_block           = var.cidr-1
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project}_security"
  }
}


#Securith VPC AZ1 Subnets

resource "aws_subnet" "sec_subnet_internet_aws_az1" {
  cidr_block              = cidrsubnet(aws_vpc.security.cidr_block, 8, 0)
  vpc_id                  = aws_vpc.security.id
  availability_zone       = var.aws_az1
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${var.project}_sec_subnet_internet_aws_az1"
  }
}

resource "aws_subnet" "sec_subnet_egress_to_ch1_aws_az1" {
  cidr_block        = cidrsubnet(aws_vpc.security.cidr_block, 8, 1)
  vpc_id            = aws_vpc.security.id
  availability_zone = var.aws_az1

  tags = {
    Name = "${var.project}_sec_subnet_egress_to_ch1_aws_az1"
  }
}

resource "aws_subnet" "sec_subnet_ingress_frm_ch1_aws_az1" {
  cidr_block        = cidrsubnet(aws_vpc.security.cidr_block, 8, 2)
  vpc_id            = aws_vpc.security.id
  availability_zone = var.aws_az1

  tags = {
    Name = "${var.project}_sec_subnet_ingress_frm_ch1_aws_az1"
  }
}

resource "aws_subnet" "sec_subnet_application_aws_az1" {
  cidr_block        = cidrsubnet(aws_vpc.security.cidr_block, 8, 3)
  vpc_id            = aws_vpc.security.id
  availability_zone = var.aws_az1

  tags = {
    Name = "${var.project}_sec_subnet_application_aws_az1"
  }
}

resource "aws_subnet" "sec_subnet_egress_to_ch2_aws_az1" {
  cidr_block        = cidrsubnet(aws_vpc.security.cidr_block, 8, 4)
  vpc_id            = aws_vpc.security.id
  availability_zone = var.aws_az1

  tags = {
    Name = "${var.project}_sec_subnet_egress_to_ch2_aws_az1"
  }
}

resource "aws_subnet" "sec_subnet_ingress_frm_ch2_aws_az1" {
  cidr_block        = cidrsubnet(aws_vpc.security.cidr_block, 8, 5)
  vpc_id            = aws_vpc.security.id
  availability_zone = var.aws_az1

  tags = {
    Name = "${var.project}_sec_subnet_ingress_frm_ch2_aws_az1"
  }
}

resource "aws_subnet" "sec_subnet_dmz_outside_aws_az1" {
  cidr_block        = cidrsubnet(aws_vpc.security.cidr_block, 8, 6)
  vpc_id            = aws_vpc.security.id
  availability_zone = var.aws_az1

  tags = {
    Name = "${var.project}_sec_subnet_dmz_outside_aws_az1"
  }
}

resource "aws_subnet" "sec_subnet_dmz_inside_aws_az1" {
  cidr_block        = cidrsubnet(aws_vpc.security.cidr_block, 8, 7)
  vpc_id            = aws_vpc.security.id
  availability_zone = var.aws_az1

  tags = {
    Name = "${var.project}_sec_subnet_dmz_inside_aws_az1"
  }
}

resource "aws_subnet" "sec_subnet_internal_aws_az1" {
  cidr_block        = cidrsubnet(aws_vpc.security.cidr_block, 8, 9)
  vpc_id            = aws_vpc.security.id
  availability_zone = var.aws_az1

  tags = {
    Name = "${var.project}_sec_subnet_internal_aws_az1"
  }
}

resource "aws_subnet" "sec_subnet_mgmt_aws_az1" {
  cidr_block        = cidrsubnet(aws_vpc.security.cidr_block, 8, 100)
  vpc_id            = aws_vpc.security.id
  availability_zone = var.aws_az1

  tags = {
    Name = "${var.project}_sec_subnet_mgmt_aws_az1"
  }
}

resource "aws_subnet" "sec_subnet_peering_aws_az1" {
  cidr_block        = cidrsubnet(aws_vpc.security.cidr_block, 8, 101)
  vpc_id            = aws_vpc.security.id
  availability_zone = var.aws_az1

  tags = {
    Name = "${var.project}_sec_subnet_peering_aws_az1"
  }
}

#Security VPC Subnets AZ2

resource "aws_subnet" "sec_subnet_internet_aws_az2" {
  cidr_block        = cidrsubnet(aws_vpc.security.cidr_block, 8, 10)
  vpc_id            = aws_vpc.security.id
  availability_zone = var.aws_az2

  tags = {
    Name = "${var.project}_sec_subnet_internet_aws_az2"
  }
}

resource "aws_subnet" "sec_subnet_egress_to_ch1_aws_az2" {
  cidr_block        = cidrsubnet(aws_vpc.security.cidr_block, 8, 11)
  vpc_id            = aws_vpc.security.id
  availability_zone = var.aws_az2

  tags = {
    Name = "${var.project}_sec_subnet_egress_to_ch1_aws_az2"
  }
}

resource "aws_subnet" "sec_subnet_ingress_frm_ch1_aws_az2" {
  cidr_block        = cidrsubnet(aws_vpc.security.cidr_block, 8, 12)
  vpc_id            = aws_vpc.security.id
  availability_zone = var.aws_az2

  tags = {
    Name = "${var.project}_sec_subnet_ingress_frm_ch1_aws_az2"
  }
}

resource "aws_subnet" "sec_subnet_egress_to_ch2_aws_az2" {
  cidr_block        = cidrsubnet(aws_vpc.security.cidr_block, 8, 14)
  vpc_id            = aws_vpc.security.id
  availability_zone = var.aws_az2

  tags = {
    Name = "${var.project}_sec_subnet_egress_to_ch2_aws_az2"
  }
}

resource "aws_subnet" "sec_subnet_ingress_frm_ch2_aws_az2" {
  cidr_block        = cidrsubnet(aws_vpc.security.cidr_block, 8, 15)
  vpc_id            = aws_vpc.security.id
  availability_zone = var.aws_az2

  tags = {
    Name = "${var.project}_sec_subnet_ingress_frm_ch2_aws_az2"
  }
}

resource "aws_subnet" "sec_subnet_dmz_outside_aws_az2" {
  cidr_block        = cidrsubnet(aws_vpc.security.cidr_block, 8, 16)
  vpc_id            = aws_vpc.security.id
  availability_zone = var.aws_az2

  tags = {
    Name = "${var.project}_sec_subnet_dmz_outside_aws_az2"
  }
}

resource "aws_subnet" "sec_subnet_dmz_inside_aws_az2" {
  cidr_block        = cidrsubnet(aws_vpc.security.cidr_block, 8, 17)
  vpc_id            = aws_vpc.security.id
  availability_zone = var.aws_az2

  tags = {
    Name = "${var.project}_sec_subnet_dmz_inside_aws_az2"
  }
}

resource "aws_subnet" "sec_subnet_application_aws_az2" {
  cidr_block        = cidrsubnet(aws_vpc.security.cidr_block, 8, 13)
  vpc_id            = aws_vpc.security.id
  availability_zone = var.aws_az2

  tags = {
    Name = "${var.project}_sec_subnet_application_aws_az2"
  }
}

resource "aws_subnet" "sec_subnet_internal_aws_az2" {
  cidr_block        = cidrsubnet(aws_vpc.security.cidr_block, 8, 19)
  vpc_id            = aws_vpc.security.id
  availability_zone = var.aws_az2

  tags = {
    Name = "${var.project}_sec_subnet_internal_aws_az2"
  }
}

resource "aws_subnet" "sec_subnet_mgmt_aws_az2" {
  cidr_block        = cidrsubnet(aws_vpc.security.cidr_block, 8, 200)
  vpc_id            = aws_vpc.security.id
  availability_zone = var.aws_az2

  tags = {
    Name = "${var.project}_sec_subnet_mgmt_aws_az2"
  }
}

resource "aws_subnet" "sec_subnet_peering_aws_az2" {
  cidr_block        = cidrsubnet(aws_vpc.security.cidr_block, 8, 201)
  vpc_id            = aws_vpc.security.id
  availability_zone = var.aws_az2

  tags = {
    Name = "${var.project}_sec_subnet_peering_aws_az2"
  }
}

#### Gateway, NAT, Route Table Creation - Security VPC ######################################################################################################################################################################################################################
#
# There are multiple route table sections - some for main route tables, and some to connect VPCs to transit Gateways. All internet facing and sourced traffic traverses the security VPC.
#
############################################################################################################################################################################################################################################################################

/*
START IGW for Security VPC
*/

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.security.id

  tags = {
    Name = "${var.project}_security-internet-gateway"
  }
}

/*
CREATE INTERNET RT security
*/

resource "aws_route_table" "internet_rt" {
  vpc_id = aws_vpc.security.id

  tags = {
    Name                    = "${var.project}_security_internet_rt",
    f5_cloud_failover_label = "external"
  }
}

# ASSOCIATE SUBNETS WITH INTERNET RT SECCURITY_VPC

resource "aws_route_table_association" "sec_subnet_internet_aws_az1" {
  route_table_id = aws_route_table.internet_rt.id
  subnet_id      = aws_subnet.sec_subnet_internet_aws_az1.id
}

resource "aws_route_table_association" "sec_subnet_mgmt_aws_az1" {
  route_table_id = aws_route_table.internet_rt.id
  subnet_id      = aws_subnet.sec_subnet_mgmt_aws_az1.id
}

resource "aws_route_table_association" "sec_subnet_internet_aws_az2" {
  route_table_id = aws_route_table.internet_rt.id
  subnet_id      = aws_subnet.sec_subnet_internet_aws_az2.id
}

resource "aws_route_table_association" "sec_subnet_mgmt_aws_az2" {
  route_table_id = aws_route_table.internet_rt.id
  subnet_id      = aws_subnet.sec_subnet_mgmt_aws_az2.id
}

/*
END SUBNET ASSOCIATION WITH INTERNET RT

#Create EIP for NAT  Gateway to allow instances in App VPC To get out
# Edit this route table if you do not want to SNAT traffic from BIG-IPs in the security VPC or if you decide to deploy SSLo
*/

resource "aws_eip" "sec_nat_az1" {
}

resource "aws_eip" "sec_nat_az2" {
}

resource "aws_nat_gateway" "sec-gw-az1" {
  allocation_id = aws_eip.sec_nat_az1.id
  subnet_id     = aws_subnet.sec_subnet_internet_aws_az1.id

  tags = {
    Name = "${var.project}_gw_az1__NAT_EIP"
  }
}

resource "aws_nat_gateway" "sec-gw-az2" {
  allocation_id = aws_eip.sec_nat_az2.id
  subnet_id     = aws_subnet.sec_subnet_internet_aws_az2.id

  tags = {
    Name = "${var.project}_gw_az2__NAT_EIP"
  }
}

#Build App Subnets Route Tables and Link Subnets

resource "aws_route_table" "sec_application_az1_rt" {
  vpc_id = aws_vpc.security.id

  tags = {
    Name = "${var.project}_sec_application_az1_rt"
  }
}

resource "aws_route_table_association" "sec_subnet_application_region-az1" {
  route_table_id = aws_route_table.sec_application_az1_rt.id
  subnet_id      = aws_subnet.sec_subnet_application_aws_az1.id
}

resource "aws_route_table" "sec_application_az2_rt" {
  vpc_id = aws_vpc.security.id

  tags = {
    Name = "${var.project}_sec_application_az2_rt"
  }
}

resource "aws_route_table_association" "sec_subnet_application_region-az2" {
  route_table_id = aws_route_table.sec_application_az2_rt.id
  subnet_id      = aws_subnet.sec_subnet_application_aws_az2.id
}

### Link Subnets with Internal Route Table

resource "aws_route_table" "sec_Internal_rt" {
  vpc_id = aws_vpc.security.id

  tags = {
    Name                    = "${var.project}_sec_Internal_rt",
    f5_cloud_failover_label = "internal"
  }
}

resource "aws_route_table_association" "sec_subnet_peering_aws_az1" {
  route_table_id = aws_route_table.sec_Internal_rt.id
  subnet_id      = aws_subnet.sec_subnet_peering_aws_az1.id
}

resource "aws_route_table_association" "sec_subnet_peering_aws_az2" {
  route_table_id = aws_route_table.sec_Internal_rt.id
  subnet_id      = aws_subnet.sec_subnet_peering_aws_az2.id
}

resource "aws_route_table_association" "sec_subnet_internal_aws_az2" {
  route_table_id = aws_route_table.sec_Internal_rt.id
  subnet_id      = aws_subnet.sec_subnet_internal_aws_az2.id
}

resource "aws_route_table_association" "sec_subnet_internal_revion-az-1" {
  route_table_id = aws_route_table.sec_Internal_rt.id
  subnet_id      = aws_subnet.sec_subnet_internal_aws_az1.id
}

#Build Sec-Applicaiton Route table and link subnets



/*
Create the First Inspection Route table Egress from BIG-IP to services
*/

resource "aws_route_table" "to_security_insepction_1_rt" {
  vpc_id = aws_vpc.security.id

  tags = {
    Name = "${var.project}_to_security_inspection_1_rt"
  }
}

## Associate subnets with the to_security_inspection_1_rt

resource "aws_route_table_association" "sec_subnet_egress_to_ch1_aws_az1" {
  route_table_id = aws_route_table.to_security_insepction_1_rt.id
  subnet_id      = aws_subnet.sec_subnet_egress_to_ch1_aws_az1.id
}

resource "aws_route_table_association" "sec_subnet_egress_to_ch1_aws_az2" {
  route_table_id = aws_route_table.to_security_insepction_1_rt.id
  subnet_id      = aws_subnet.sec_subnet_egress_to_ch1_aws_az2.id
}

resource "aws_route_table_association" "sec_subnet_dmz_outside_aws_az1" {
  route_table_id = aws_route_table.to_security_insepction_1_rt.id
  subnet_id      = aws_subnet.sec_subnet_dmz_outside_aws_az1.id
}

resource "aws_route_table_association" "sec_subnet_dmz_outside_aws_az2" {
  route_table_id = aws_route_table.to_security_insepction_1_rt.id
  subnet_id      = aws_subnet.sec_subnet_dmz_outside_aws_az2.id
}

/*
Creat Security Chain 1 Ingress Chain Route Table back to Big-IP
*/

resource "aws_route_table" "frm_security_insepction_1_rt" {
  vpc_id = aws_vpc.security.id

  tags = {
    Name = "${var.project}_frm_security_inspection_1_rt"
  }
}

resource "aws_route_table_association" "sec_subnet_ingress_frm_ch1_aws_az1" {
  route_table_id = aws_route_table.frm_security_insepction_1_rt.id
  subnet_id      = aws_subnet.sec_subnet_ingress_frm_ch1_aws_az1.id
}

resource "aws_route_table_association" "sec_subnet_ingress_frm_ch1_aws_az2" {
  route_table_id = aws_route_table.frm_security_insepction_1_rt.id
  subnet_id      = aws_subnet.sec_subnet_ingress_frm_ch1_aws_az2.id
}

resource "aws_route_table_association" "sec_subnet_dmz_inside_aws_az1" {
  route_table_id = aws_route_table.frm_security_insepction_1_rt.id
  subnet_id      = aws_subnet.sec_subnet_dmz_inside_aws_az1.id
}

resource "aws_route_table_association" "sec_subnet_dmz_inside_aws_az2" {
  route_table_id = aws_route_table.frm_security_insepction_1_rt.id
  subnet_id      = aws_subnet.sec_subnet_dmz_inside_aws_az2.id
}

## Create the Second Inspection Route table Egress from BIG-IP to security servcies

resource "aws_route_table" "to_security_insepction_2_rt" {
  vpc_id = aws_vpc.security.id

  tags = {
    Name = "${var.project}_to_security_inspection_2_rt"
  }
}

resource "aws_route_table_association" "sec_subnet_egress_to_ch2_aws_az1" {
  route_table_id = aws_route_table.to_security_insepction_2_rt.id
  subnet_id      = aws_subnet.sec_subnet_egress_to_ch2_aws_az1.id
}

resource "aws_route_table_association" "sec_subnet_egress_to_ch2_aws_az2" {
  route_table_id = aws_route_table.to_security_insepction_2_rt.id
  subnet_id      = aws_subnet.sec_subnet_egress_to_ch2_aws_az2.id
}


/*
Creat Security Chain 2 Ingress Chain Route Table back to Big-IP
*/
resource "aws_route_table" "frm_security_insepction_2_rt" {
  vpc_id = aws_vpc.security.id

  tags = {
    Name = "${var.project}_frm_security_inspection_2_rt"
  }
}

resource "aws_route_table_association" "sec_subnet_ingress_frm_ch2_aws_az1" {
  route_table_id = aws_route_table.frm_security_insepction_2_rt.id
  subnet_id      = aws_subnet.sec_subnet_ingress_frm_ch2_aws_az1.id
}

resource "aws_route_table_association" "sec_subnet_ingress_frm_ch2_aws_az2" {
  route_table_id = aws_route_table.frm_security_insepction_2_rt.id
  subnet_id      = aws_subnet.sec_subnet_ingress_frm_ch2_aws_az2.id
}


#Enpoint Security Group

resource "aws_security_group" "sg_internal_security_vpc" {
  description = "wide open"
  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = [var.cidr-1]
  }
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = [var.cidr-1]
  }
  vpc_id = aws_vpc.security.id
}


# Create S3 VPC Endpoint
resource "aws_vpc_endpoint" "s3-security" {
  vpc_id       = aws_vpc.security.id
  service_name = "com.amazonaws.${var.aws_region}.s3"
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  vpc_endpoint_id = aws_vpc_endpoint.s3-security.id
  route_table_id  = aws_route_table.sec_Internal_rt.id
}

resource "aws_vpc_endpoint_route_table_association" "private_application_s3_az1" {
  vpc_endpoint_id = aws_vpc_endpoint.s3-security.id
  route_table_id  = aws_route_table.sec_application_az1_rt.id
}

resource "aws_vpc_endpoint_route_table_association" "private_application_s3_az2" {
  vpc_endpoint_id = aws_vpc_endpoint.s3-security.id
  route_table_id  = aws_route_table.sec_application_az2_rt.id
}


# Create EC2 VPC Endpoint
resource "aws_vpc_endpoint" "ec2" {
  vpc_id            = aws_vpc.security.id
  service_name      = "com.amazonaws.${var.aws_region}.ec2"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.sg_internal_security_vpc.id]

  private_dns_enabled = true
  subnet_ids          = [aws_subnet.sec_subnet_application_aws_az1.id, aws_subnet.sec_subnet_application_aws_az2.id]
}

# Create Cloudwatch VPC Endpoint
resource "aws_vpc_endpoint" "logs" {
  vpc_id            = aws_vpc.security.id
  service_name      = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.sg_internal_security_vpc.id]

  private_dns_enabled = true
  subnet_ids          = [aws_subnet.sec_subnet_application_aws_az1.id, aws_subnet.sec_subnet_application_aws_az2.id]

}
