/* ## F5 Networks Secure Cloud Migration and Securty Zone Template for AWS ####################################################################################################################################################################################
Version 1.4
March 2020


This Template is provided as is and without warranty or support.  It is intended for demonstration or reference purposes. While all attempts are made to ensure it functions as desired it is not a supported by F5 Networks.  This template can be used
to quickly deploy a Security VPC - aka DMZ, in-front of the your application VPC(S).  Additional VPCs can be added to the template by adding CIDR variables, VPC resource blocks, VPC specific route tables
and TransitGateway edits. Limits to VPCs that can be added are =to the limits of transit gateway.

It is built to run in a region with three zones to use and will place services in 1a and 1c.  Modifications to other zones can be done.

F5 Application Services will be deployed into the security VPC but if one wished they could also be deployed inside of the Application VPCs.

*/
################################################################################################################################################################################################################################################################
################################################################################################################################################################################################################################################################
#
#  Output VPCs
#
################################################################################################################################################################################################################################################################

output "security" {
  value       = aws_vpc.security.id
  description = "The security houses F5 systems, IPS systems and functions as the traffic control point for north/south traffic"
}

output "application" {
  value       = aws_vpc.application.id
  description = "The application VPC is a container to demo applications, it is seperated from the K8S VPC just for clarity in discussion and demonstration, not for technical requirements"
}

output "containers" {
  value       = aws_vpc.containers.id
  description = "The containers VPC is a container to demo applications, it is seperated from the application VPC just for clarity in discussion and demonstration, not for technical requirements"
}

################################################################################################################################################################################################################################################################
#
#  Output Subnets
#
################################################################################################################################################################################################################################################################

output "sec_subnet_internet_aws_az1" {
  value       = aws_subnet.sec_subnet_internet_aws_az1.id
  description = "This subnet is where the external interfaces of the internet facing BIG-IPs (ETH2) will be placed."
}

output "sec_subnet_egress_to_ch1_aws_az1" {
  value       = aws_subnet.sec_subnet_egress_to_ch1_aws_az1.id
  description = "If using SSLo this is the network that leaves F5 and goes to the security systems for chain 1"
}

output "sec_subnet_ingress_frm_ch1_aws_az1" {
  value       = aws_subnet.sec_subnet_ingress_frm_ch1_aws_az1.id
  description = "If using SSLo this is the network that leaves the security devices and returns to F5 for chain 1"
}

output "sec_subnet_application_aws_az1" {
  value       = aws_subnet.sec_subnet_application_aws_az1.id
  description = "Place the BIG-IP (ETH1) interfaces here for onboarding via NAT, "
}

output "sec_subnet_internal_aws_az1" {
  value       = aws_subnet.sec_subnet_internal_aws_az1.id
  description = "Place the inside BIG-IP internal interfaces here "
}

output "sec_subnet_internal_aws_az2" {
  value       = aws_subnet.sec_subnet_internal_aws_az2.id
  description = "Place the inside BIG-IP internal interfaces here"
}

output "sec_subnet_egress_to_ch2_aws_az1" {
  value       = aws_subnet.sec_subnet_egress_to_ch2_aws_az1.id
  description = "If using SSLo this is the network that leaves the security devices and returns to F5 for chain 2"
}

output "sec_subnet_ingress_frm_ch2_aws_az1" {
  value       = aws_subnet.sec_subnet_ingress_frm_ch2_aws_az1.id
  description = "If using SSLo this is the network that leaves the security devices and returns to F5 for chain 2"
}

output "sec_subnet_dmz_outside_aws_az1" {
  value       = aws_subnet.sec_subnet_dmz_outside_aws_az1.id
  description = "DMZ interfaces are for inspection zones outside = the north interface of the IPS system. Inside = the south interface of the IPS"
}

output "sec_subnet_dmz_inside_aws_az1" {
  value       = aws_subnet.sec_subnet_dmz_inside_aws_az1.id
  description = "DMZ interfaces are for inspection zones outside = the north interface of the IPS system. Inside = the south interface of the IPS"
}

output "sec_subnet_mgmt_aws_az1" {
  value       = aws_subnet.sec_subnet_mgmt_aws_az1.id
  description = "Mgmt networks in the security VPC are for devices that have dedicated mgmt interfaces or other hosts that need internet access without traversing the security stack. By defaulty you will need an EIP but you could use a NAT Gateway"
}

output "sec_subnet_peering_aws_az1" {
  value       = aws_subnet.sec_subnet_peering_aws_az1.id
  description = "Peering networks are for ENIs to reach other VPCs or external to AWS Locations"
}

output "sec_subnet_internet_aws_az2" {
  value       = aws_subnet.sec_subnet_internet_aws_az2.id
  description = "This subnet is where the external interfaces of the internet facing BIG-IPs (ETH2) will be placed."
}

output "sec_subnet_egress_to_ch1_aws_az2" {
  value       = aws_subnet.sec_subnet_egress_to_ch1_aws_az2.id
  description = "If using SSLo this is the network that leaves F5 and goes to the security systems for chain 1"
}

output "sec_subnet_ingress_frm_ch1_aws_az2" {
  value       = aws_subnet.sec_subnet_ingress_frm_ch1_aws_az2.id
  description = "If using SSLo this is the network that leaves the security devices and returns to F5 for chain 1"
}

output "sec_subnet_egress_to_ch2_aws_az2" {
  value       = aws_subnet.sec_subnet_egress_to_ch2_aws_az2.id
  description = "If using SSLo this is the network that leaves F5 and goes to the security systems for chain 2"
}

output "sec_subnet_ingress_frm_ch2_aws_az2" {
  value       = aws_subnet.sec_subnet_ingress_frm_ch2_aws_az2.id
  description = "If using SSLo this is the network that leaves the security devices and returns to F5 for chain 2"
}

output "sec_subnet_dmz_outside_aws_az2" {
  value       = aws_subnet.sec_subnet_dmz_outside_aws_az2.id
  description = "DMZ interfaces are for inspection zones outside = the north interface of the IPS system. Inside = the south interface of the IPS"
}

output "sec_subnet_dmz_inside_aws_az2" {
  value       = aws_subnet.sec_subnet_dmz_inside_aws_az2.id
  description = "DMZ interfaces are for inspection zones outside = the north interface of the IPS system. Inside = the south interface of the IPS"
}

output "sec_subnet_application_aws_az2" {
  value       = aws_subnet.sec_subnet_application_aws_az2.id
  description = "Tenant VPC Internet/DMZ subnets are for use cases where the Security VPC to Tenant VPC is not considered a trusted network, these allow for increased segmentation and secruity insertion with additional route tables "
}

output "sec_subnet_mgmt_aws_az2" {
  value       = aws_subnet.sec_subnet_mgmt_aws_az2.id
  description = "Mgmt networks in the security VPC are for devices that have dedicated mgmt interfaces or other hosts that need internet access without traversing the security stack. By defaulty you will need an EIP but you could use a NAT Gateway"
}

output "sec_subnet_peering_aws_az2" {
  value       = aws_subnet.sec_subnet_peering_aws_az2.id
  description = "Peering networks are for ENIs to reach other VPCs or external to AWS Locations"
}


output "app_subnet_internet_aws_az1" {
  value       = aws_subnet.app_subnet_internet_aws_az1.id
  description = "This subnet is where the external interfaces of the internet facing BIG-IPs (ETH2) will be placed."
}

output "app_subnet_dmz_1_aws_az1" {
  value       = aws_subnet.app_subnet_dmz_1_aws_az1.id
  description = "Tenant VPC Internet/DMZ subnets are for use cases where the Security VPC to Tenant VPC is not considered a trusted network, these allow for increased segmentation and secruity insertion with additional route tables "
}

output "app_subnet_application_aws_az1" {
  value       = aws_subnet.app_subnet_application_aws_az1.id
  description = "Place the BIG-IP (ETH1) interfaces here for onboarding via NAT, "
}

output "app_subnet_peering_aws_az1" {
  value       = aws_subnet.app_subnet_peering_aws_az1.id
  description = "Peering networks are for ENIs to reach other VPCs or external to AWS Locations"
}

output "app_subnet_mgmt_aws_az1" {
  value       = aws_subnet.app_subnet_mgmt_aws_az1.id
  description = "Tenant mgmt networks allow for isolation of mgmt interfaces/instances if necessary"
}

output "app_subnet_internet_aws_az2" {
  value       = aws_subnet.app_subnet_internet_aws_az2.id
  description = "Tenant VPC Internet/DMZ subnets are for use cases where the Security VPC to Tenant VPC is not considered a trusted network, these allow for increased segmentation and secruity insertion with additional route tables "
}

output "app_subnet_dmz_1_aws_az2" {
  value       = aws_subnet.app_subnet_dmz_1_aws_az2.id
  description = "Tenant VPC Internet/DMZ subnets are for use cases where the Security VPC to Tenant VPC is not considered a trusted network, these allow for increased segmentation and secruity insertion with additional route tables "
}

output "app_subnet_application_aws_az2" {
  value       = aws_subnet.app_subnet_application_aws_az2.id
  description = "Tenant VPC Internet/DMZ subnets are for use cases where the Security VPC to Tenant VPC is not considered a trusted network, these allow for increased segmentation and secruity insertion with additional route tables "
}

output "app_subnet_peering_aws_az2" {
  value       = aws_subnet.app_subnet_peering_aws_az2.id
  description = "Peering networks are for ENIs to reach other VPCs or external to AWS Locations"
}

output "app_subnet_mgmt_aws_az2" {
  value       = aws_subnet.app_subnet_mgmt_aws_az2.id
  description = "Tenant mgmt networks allow for isolation of mgmt interfaces/instances if necessary"
}

output "container_subnet_internet_aws_az1" {
  value       = aws_subnet.container_subnet_internet_aws_az1.id
  description = "Tenant VPC Internet/DMZ subnets are for use cases where the Security VPC to Tenant VPC is not considered a trusted network, these allow for increased segmentation and secruity insertion with additional route tables "
}

output "container_subnet_dmz_1_aws_az1" {
  value       = aws_subnet.container_subnet_dmz_1_aws_az1.id
  description = "Tenant VPC Internet/DMZ subnets are for use cases where the Security VPC to Tenant VPC is not considered a trusted network, these allow for increased segmentation and secruity insertion with additional route tables "
}

output "container_subnet_application_aws_az1" {
  value       = aws_subnet.container_subnet_application_aws_az1.id
  description = "Tenant Application subnets are place holders to deploy server or conatiner workloads"
}

output "container_subnet_peering_aws_az1" {
  value       = aws_subnet.container_subnet_peering_aws_az1.id
  description = "Peering networks are for ENIs to reach other VPCs or external to AWS Locations"
}

output "container_subnet_mgmt_aws_az1" {
  value       = aws_subnet.container_subnet_mgmt_aws_az1.id
  description = "Tenant mgmt networks allow for isolation of mgmt interfaces/instances if necessary"
}

output "container_subnet_internet_aws_az2" {
  value       = aws_subnet.container_subnet_internet_aws_az2.id
  description = "Tenant VPC Internet/DMZ subnets are for use cases where the Security VPC to Tenant VPC is not considered a trusted network, these allow for increased segmentation and secruity insertion with additional route tables "
}

output "container_subnet_dmz_1_aws_az2" {
  value       = aws_subnet.container_subnet_dmz_1_aws_az2.id
  description = "Tenant VPC Internet/DMZ subnets are for use cases where the Security VPC to Tenant VPC is not considered a trusted network, these allow for increased segmentation and secruity insertion with additional route tables "
}

output "container_subnet_application_aws_az2" {
  value       = aws_subnet.container_subnet_application_aws_az2.id
  description = "Tenant VPC Internet/DMZ subnets are for use cases where the Security VPC to Tenant VPC is not considered a trusted network, these allow for increased segmentation and secruity insertion with additional route tables "
}

output "container_subnet_peering_aws_az2" {
  value       = aws_subnet.container_subnet_peering_aws_az2.id
  description = "Peering networks are for ENIs to reach other VPCs or external to AWS Locations"
}
output "container_subnet_mgmt_aws_az2" {
  value       = aws_subnet.container_subnet_mgmt_aws_az2.id
  description = "Tenant mgmt networks allow for isolation of mgmt interfaces/instances if necessary"
}

################################################################################################################################################################################################################################################################
#
#   Output Route Tables
#
################################################################################################################################################################################################################################################################

output "internet_rt" {
  value       = aws_route_table.internet_rt.id
  description = "This is the Security VPC Internet route table, interfaces/subnets here require an EIP"
}

output "sec_Internal_rt" {
  value       = aws_route_table.sec_Internal_rt.id
  description = "This is the internal route table of the Security VPC and has the connections to Tenants. At deployment time there is a 0.0.0.0/0 to a NAT Gateway to allow onboarding prior to the security stack being complete"
}


output "to_security_insepction_1_rt" {
  value       = aws_route_table.to_security_insepction_1_rt.id
  description = "Isolated route table for SSlo. No internet access or tenant VPC access"
}

output "frm_security_insepction_1_rt" {
  value       = aws_route_table.frm_security_insepction_1_rt.id
  description = "Isolated route table for SSlo. No internet access or tenant VPC access"
}

output "to_security_insepction_2_rt" {
  value       = aws_route_table.to_security_insepction_2_rt.id
  description = "Isolated route table for SSlo. No internet access or tenant VPC access"
}

output "frm_security_insepction_2_rt" {
  value       = aws_route_table.frm_security_insepction_2_rt.id
  description = "Isolated route table for SSlo. No internet access or tenant VPC access"
}

output "app_tgw_main_rt" {
  value       = aws_route_table.app_tgw_main_rt.id
  description = "application VPC route table - all traffic goes to TGW and enters the security VPC in the sec_Internal_rt"
}

output "container_tgw_main_rt" {
  value       = aws_route_table.container_tgw_main_rt.id
  description = "application VPC route table - all traffic goes to TGW and enters the security VPC in the sec_Internal_rt"
}

output "sec_application_az1_rt" {
  value       = aws_route_table.sec_application_az1_rt.id
  description = "Security VPC route table for infrastructure applications that may need egress via NAT"
}

output "sec_application_az2_rt" {
  value       = aws_route_table.sec_application_az2_rt.id
  description = "Security VPC route table for infrastructure applications that may need egress via NAT"
}

################################################################################################################################################################################################################################################################
#
#   Output TGW and TGW Route Tables
#
################################################################################################################################################################################################################################################################


output "security-app-tgw" {
  value = aws_ec2_transit_gateway.security-app-tgw.id
}

output "security-app-tgw-main-rt" {
  value       = aws_ec2_transit_gateway_route_table.security-app-tgw-main-rt.id
  description = "All VPCs are connected to this tgw route table and it allows traffic to flow between them"
}

################################################################################################################################################################################################################################################################
#
#   Output CIDRs
#
################################################################################################################################################################################################################################################################

output "cidr-1" {
  value = var.cidr-1
}

output "cidr-2" {
  value = var.cidr-2
}

output "cidr-3" {
  value = var.cidr-3
}

################################################################################################################################################################################################################################################################
#
#   Output Subnets and AWS IP for Routes
#
################################################################################################################################################################################################################################################################

output "sec_subnet_internet_aws_az1-subnet" { value = aws_subnet.sec_subnet_internet_aws_az1.cidr_block }
output "sec_subnet_egress_to_ch1_aws_az1-subnet" { value = aws_subnet.sec_subnet_egress_to_ch1_aws_az1.cidr_block }
output "sec_subnet_ingress_frm_ch1_aws_az1-subnet" { value = aws_subnet.sec_subnet_ingress_frm_ch1_aws_az1.cidr_block }
output "sec_subnet_application_aws_az1-subnet" { value = aws_subnet.sec_subnet_application_aws_az1.cidr_block }
output "sec_subnet_egress_to_ch2_aws_az1-subnet" { value = aws_subnet.sec_subnet_egress_to_ch2_aws_az1.cidr_block }
output "sec_subnet_ingress_frm_ch2_aws_az1-subnet" { value = aws_subnet.sec_subnet_ingress_frm_ch2_aws_az1.cidr_block }
output "sec_subnet_dmz_outside_aws_az1-subnet" { value = aws_subnet.sec_subnet_dmz_outside_aws_az1.cidr_block }
output "sec_subnet_dmz_inside_aws_az1-subnet" { value = aws_subnet.sec_subnet_dmz_inside_aws_az1.cidr_block }
output "sec_subnet_internal_aws_az1-subnet" { value = aws_subnet.sec_subnet_internal_aws_az1.cidr_block }
output "sec_subnet_mgmt_aws_az1-subnet" { value = aws_subnet.sec_subnet_mgmt_aws_az1.cidr_block }
output "sec_subnet_peering_aws_az1-subnet" { value = aws_subnet.sec_subnet_peering_aws_az1.cidr_block }
output "sec_subnet_internet_aws_az2-subnet" { value = aws_subnet.sec_subnet_internet_aws_az2.cidr_block }
output "sec_subnet_egress_to_ch1_aws_az2-subnet" { value = aws_subnet.sec_subnet_egress_to_ch1_aws_az2.cidr_block }
output "sec_subnet_ingress_frm_ch1_aws_az2-subnet" { value = aws_subnet.sec_subnet_ingress_frm_ch1_aws_az2.cidr_block }
output "sec_subnet_egress_to_ch2_aws_az2-subnet" { value = aws_subnet.sec_subnet_egress_to_ch2_aws_az2.cidr_block }
output "sec_subnet_ingress_frm_ch2_aws_az2-subnet" { value = aws_subnet.sec_subnet_ingress_frm_ch2_aws_az2.cidr_block }
output "sec_subnet_dmz_outside_aws_az2-subnet" { value = aws_subnet.sec_subnet_dmz_outside_aws_az2.cidr_block }
output "sec_subnet_dmz_inside_aws_az2-subnet" { value = aws_subnet.sec_subnet_dmz_inside_aws_az2.cidr_block }
output "sec_subnet_application_aws_az2-subnet" { value = aws_subnet.sec_subnet_application_aws_az2.cidr_block }
output "sec_subnet_internal_aws_az2-subnet" { value = aws_subnet.sec_subnet_internal_aws_az2.cidr_block }
output "sec_subnet_mgmt_aws_az2-subnet" { value = aws_subnet.sec_subnet_mgmt_aws_az2.cidr_block }
output "sec_subnet_peering_aws_az2-subnet" { value = aws_subnet.sec_subnet_peering_aws_az2.cidr_block }

output "app_subnet_internet_aws_az1-subnet" { value = aws_subnet.app_subnet_internet_aws_az1.cidr_block }
output "app_subnet_dmz_1_aws_az1-subnet" { value = aws_subnet.app_subnet_dmz_1_aws_az1.cidr_block }
output "app_subnet_application_aws_az1-subnet" { value = aws_subnet.app_subnet_application_aws_az1.cidr_block }
output "app_subnet_peering_aws_az1-subnet" { value = aws_subnet.app_subnet_peering_aws_az1.cidr_block }
output "app_subnet_mgmt_aws_az1-subnet" { value = aws_subnet.app_subnet_mgmt_aws_az1.cidr_block }
output "app_subnet_internet_aws_az2-subnet" { value = aws_subnet.app_subnet_internet_aws_az2.cidr_block }
output "app_subnet_dmz_1_aws_az2-subnet" { value = aws_subnet.app_subnet_dmz_1_aws_az2.cidr_block }
output "app_subnet_application_aws_az2-subnet" { value = aws_subnet.app_subnet_application_aws_az2.cidr_block }
output "app_subnet_peering_aws_az2-subnet" { value = aws_subnet.app_subnet_peering_aws_az2.cidr_block }
output "app_subnet_mgmt_aws_az2-subnet" { value = aws_subnet.app_subnet_mgmt_aws_az2.cidr_block }

output "container_subnet_internet_aws_az1-subnet" { value = aws_subnet.container_subnet_internet_aws_az1.cidr_block }
output "container_subnet_dmz_1_aws_az1-subnet" { value = aws_subnet.container_subnet_dmz_1_aws_az1.cidr_block }
output "container_subnet_application_aws_az1-subnet" { value = aws_subnet.container_subnet_application_aws_az1.cidr_block }
output "container_subnet_peering_aws_az1-subnet" { value = aws_subnet.container_subnet_peering_aws_az1.cidr_block }
output "container_subnet_mgmt_aws_az1-subnet" { value = aws_subnet.container_subnet_mgmt_aws_az1.cidr_block }
output "container_subnet_internet_aws_az2-subnet" { value = aws_subnet.container_subnet_internet_aws_az2.cidr_block }
output "container_subnet_dmz_1_aws_az2-subnet" { value = aws_subnet.container_subnet_dmz_1_aws_az2.cidr_block }
output "container_subnet_application_aws_az2-subnet" { value = aws_subnet.container_subnet_application_aws_az2.cidr_block }
output "container_subnet_peering_aws_az2-subnet" { value = aws_subnet.container_subnet_peering_aws_az2.cidr_block }
output "container_subnet_mgmt_aws_az2-subnet" { value = aws_subnet.container_subnet_mgmt_aws_az2.cidr_block }

output "container_subnet_internet_aws_az1-aws-ip" { value = cidrhost(aws_subnet.container_subnet_internet_aws_az1.cidr_block, 1) }
output "container_subnet_dmz_1_aws_az1-aws-ip" { value = cidrhost(aws_subnet.container_subnet_dmz_1_aws_az1.cidr_block, 1) }
output "container_subnet_application_aws_az1-aws-ip" { value = cidrhost(aws_subnet.container_subnet_application_aws_az1.cidr_block, 1) }
output "container_subnet_peering_aws_az1-aws-ip" { value = cidrhost(aws_subnet.container_subnet_peering_aws_az1.cidr_block, 1) }
output "container_subnet_mgmt_aws_az1-aws-ip" { value = cidrhost(aws_subnet.container_subnet_mgmt_aws_az1.cidr_block, 1) }
output "container_subnet_internet_aws_az2-aws-ip" { value = cidrhost(aws_subnet.container_subnet_internet_aws_az2.cidr_block, 1) }
output "container_subnet_dmz_1_aws_az2-aws-ip" { value = cidrhost(aws_subnet.container_subnet_dmz_1_aws_az2.cidr_block, 1) }
output "container_subnet_application_aws_az2-aws-ip" { value = cidrhost(aws_subnet.container_subnet_application_aws_az2.cidr_block, 1) }
output "container_subnet_peering_aws_az2-aws-ip" { value = cidrhost(aws_subnet.container_subnet_peering_aws_az2.cidr_block, 1) }
output "container_subnet_mgmt_aws_az2-aws-ip" { value = cidrhost(aws_subnet.container_subnet_mgmt_aws_az2.cidr_block, 1) }

output "app_subnet_internet_aws_az1-aws-ip" { value = cidrhost(aws_subnet.app_subnet_internet_aws_az1.cidr_block, 1) }
output "app_subnet_dmz_1_aws_az1-aws-ip" { value = cidrhost(aws_subnet.app_subnet_dmz_1_aws_az1.cidr_block, 1) }
output "app_subnet_application_aws_az1-aws-ip" { value = cidrhost(aws_subnet.app_subnet_application_aws_az1.cidr_block, 1) }
output "app_subnet_peering_aws_az1-aws-ip" { value = cidrhost(aws_subnet.app_subnet_peering_aws_az1.cidr_block, 1) }
output "app_subnet_mgmt_aws_az1-aws-ip" { value = cidrhost(aws_subnet.app_subnet_mgmt_aws_az1.cidr_block, 1) }
output "app_subnet_internet_aws_az2-aws-ip" { value = cidrhost(aws_subnet.app_subnet_internet_aws_az2.cidr_block, 1) }
output "app_subnet_dmz_1_aws_az2-aws-ip" { value = cidrhost(aws_subnet.app_subnet_dmz_1_aws_az2.cidr_block, 1) }
output "app_subnet_application_aws_az2-aws-ip" { value = cidrhost(aws_subnet.app_subnet_application_aws_az2.cidr_block, 1) }
output "app_subnet_peering_aws_az2-aws-ip" { value = cidrhost(aws_subnet.app_subnet_peering_aws_az2.cidr_block, 1) }
output "app_subnet_mgmt_aws_az2-aws-ip" { value = cidrhost(aws_subnet.app_subnet_mgmt_aws_az2.cidr_block, 1) }

output "sec_subnet_internet_aws_az1-aws-ip" { value = cidrhost(aws_subnet.sec_subnet_internet_aws_az1.cidr_block, 1) }
output "sec_subnet_egress_to_ch1_aws_az1-aws-ip" { value = cidrhost(aws_subnet.sec_subnet_egress_to_ch1_aws_az1.cidr_block, 1) }
output "sec_subnet_ingress_frm_ch1_aws_az1-aws-ip" { value = cidrhost(aws_subnet.sec_subnet_ingress_frm_ch1_aws_az1.cidr_block, 1) }
output "sec_subnet_application_aws_az1-aws-ip" { value = cidrhost(aws_subnet.sec_subnet_application_aws_az1.cidr_block, 1) }
output "sec_subnet_egress_to_ch2_aws_az1-aws-ip" { value = cidrhost(aws_subnet.sec_subnet_egress_to_ch2_aws_az1.cidr_block, 1) }
output "sec_subnet_ingress_frm_ch2_aws_az1-aws-ip" { value = cidrhost(aws_subnet.sec_subnet_ingress_frm_ch2_aws_az1.cidr_block, 1) }
output "sec_subnet_dmz_outside_aws_az1-aws-ip" { value = cidrhost(aws_subnet.sec_subnet_dmz_outside_aws_az1.cidr_block, 1) }
output "sec_subnet_dmz_inside_aws_az1-aws-ip" { value = cidrhost(aws_subnet.sec_subnet_dmz_inside_aws_az1.cidr_block, 1) }
output "sec_subnet_internal_aws_az1-aws-ip" { value = cidrhost(aws_subnet.sec_subnet_internal_aws_az1.cidr_block, 1) }
output "sec_subnet_mgmt_aws_az1-aws-ip" { value = cidrhost(aws_subnet.sec_subnet_mgmt_aws_az1.cidr_block, 1) }
output "sec_subnet_peering_aws_az1-aws-ip" { value = cidrhost(aws_subnet.sec_subnet_peering_aws_az1.cidr_block, 1) }
output "sec_subnet_internet_aws_az2-aws-ip" { value = cidrhost(aws_subnet.sec_subnet_internet_aws_az2.cidr_block, 1) }
output "sec_subnet_egress_to_ch1_aws_az2-aws-ip" { value = cidrhost(aws_subnet.sec_subnet_egress_to_ch1_aws_az2.cidr_block, 1) }
output "sec_subnet_ingress_frm_ch1_aws_az2-aws-ip" { value = cidrhost(aws_subnet.sec_subnet_ingress_frm_ch1_aws_az2.cidr_block, 1) }
output "sec_subnet_egress_to_ch2_aws_az2-aws-ip" { value = cidrhost(aws_subnet.sec_subnet_egress_to_ch2_aws_az2.cidr_block, 1) }
output "sec_subnet_ingress_frm_ch2_aws_az2-aws-ip" { value = cidrhost(aws_subnet.sec_subnet_ingress_frm_ch2_aws_az2.cidr_block, 1) }
output "sec_subnet_dmz_outside_aws_az2-aws-ip" { value = cidrhost(aws_subnet.sec_subnet_dmz_outside_aws_az2.cidr_block, 1) }
output "sec_subnet_dmz_inside_aws_az2-aws-ip" { value = cidrhost(aws_subnet.sec_subnet_dmz_inside_aws_az2.cidr_block, 1) }
output "sec_subnet_application_aws_az2-aws-ip" { value = cidrhost(aws_subnet.sec_subnet_application_aws_az2.cidr_block, 1) }
output "sec_subnet_internal_aws_az2-aws-ip" { value = cidrhost(aws_subnet.sec_subnet_internal_aws_az2.cidr_block, 1) }
output "sec_subnet_mgmt_aws_az2-aws-ip" { value = cidrhost(aws_subnet.sec_subnet_mgmt_aws_az2.cidr_block, 1) }
output "sec_subnet_peering_aws_az2-aws-ip" { value = cidrhost(aws_subnet.sec_subnet_peering_aws_az2.cidr_block, 1) }

output "CFE_external_route_table_tag" { value = aws_route_table.internet_rt.tags["f5_cloud_failover_label"] }
output "CFE_internal_route_table_tag" { value = aws_route_table.sec_Internal_rt.tags["f5_cloud_failover_label"] }


// custom

locals {
  vpcs = {
    "security"    = aws_vpc.security.id
    "application" = aws_vpc.application.id
    "containers"  = aws_vpc.containers.id
  }
  subnets = {
    "sec_subnet_internet_aws_az1"       = aws_subnet.sec_subnet_internet_aws_az1.id
    "sec_subnet_internet_aws_az2"       = aws_subnet.sec_subnet_internet_aws_az2.id
    "app_subnet_internet_aws_az1"       = aws_subnet.app_subnet_internet_aws_az1.id
    "app_subnet_internet_aws_az2"       = aws_subnet.app_subnet_internet_aws_az2.id
    "container_subnet_internet_aws_az1" = aws_subnet.container_subnet_internet_aws_az1.id
    "container_subnet_internet_aws_az2" = aws_subnet.container_subnet_internet_aws_az2.id
  }
}
