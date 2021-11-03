#
# Variables Configuration
#
# Variables for resources
variable "location" {  default = "East US 2"}
variable "resource_group_name" {  default = ""}
variable "network_cidr" {  default = ""}
variable "mgmt_subnet_prefix" {  default = ""}
variable "external_subnet_prefix" {  default = ""}
variable "internal_subnet_prefix" {  default = ""}

#variables for AzureRM provider
#variable "client_id" {  default = ""}
#variable "subscription_id" {  default = ""}
#variable "tenant_id" {  default = ""}
#variable "client_secret" {  default = ""}