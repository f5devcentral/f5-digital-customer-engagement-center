output "aws_infra" {
  description = "AWS VPC ID for the created VPC"
  value = {
    vpc_id          = module.vpc.vpc_id,
    vpc_cidr_block  = module.vpc.vpc_cidr_block,
    mgmt_subnets    = module.vpc.database_subnets,
    public_subnets  = module.vpc.private_subnets,
    private_subnets = module.vpc.private_subnets
  }
}