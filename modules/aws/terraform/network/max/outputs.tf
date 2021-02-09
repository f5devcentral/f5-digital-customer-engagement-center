# VPC
output "awsVpcId" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "awsVpcCidr" {
  description = "The CIDR block of the VPC"
  value       = concat(module.vpc.*.vpc_cidr_block,[""])[0]
}

# Subnets
output "awsPrivateSubnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "awsPublicSubnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "awsManagementSubnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc.database_subnets
}