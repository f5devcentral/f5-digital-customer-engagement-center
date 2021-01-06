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

##### AWS Region Variables ###################################################################################################################################################################################################################################
#
#  The variables below deine the AWS retion that you will deploy to.  The template is desinged for a region with 3 zones, and relies upon the user credentials already in their profile.
#
#############################################################################################################################################################################################################################################################

variable "aws_region" {
  description = "aws region "
  default     = "us-west-2"
}

##### Tag Variable  #######################################################################################################################################################################################################################################
#
#  The field below is used to create the naming for tags for created resrouces. This helps identify the objects that are created by the template.
#
############################################################################################################################################################################################################################################################

variable "project" {
  description = "project name to use for tags"
  default     = "f5-dcec"
}

##### CIDR Variables  #######################################################################################################################################################################################################################################
#
#  The CIDR blocks are used in the VPCs (cidr-number) and are used to restrict access to the environment (cidr-customer-source)
#
############################################################################################################################################################################################################################################################

variable "cidr-1" {
  description = "CIDR block for the Security VPC"
  default     = "10.100.0.0/16"
}

variable "cidr-2" {
  description = "CIDR block for the Applicaiton VPC"
  default     = "10.200.0.0/16"
}

variable "cidr-3" {
  description = "CIDR block for the Container VPC"
  default     = "10.240.0.0/16"
}

variable "cidr-customer-source" {
  description = "Allow Access to services from Customer CIDR Range"
  default     = "0.0.0.0/0"
}

##### Region Variables  #######################################################################################################################################################################################################################################
#
#  Set the Avaibility Zones that we will use to create our deployment.
#
###############################################################################################################################################################################################################################################################

variable "aws_az1" {
  description = "This becomes AZ_1"
}

variable "aws_az2" {
  description = "This becomes AZ_2"
}


variable "random_id" {
  description = "random hex suffix for resources"
}

variable "cluster_name" {
  description = "clustername for k8s"
  default     = "my-cluster"
}
