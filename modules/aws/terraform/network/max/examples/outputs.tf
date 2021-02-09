output "awsInfra" {
  description = "AWS VPC ID for the created VPC"
  value = {
    vpcId          = module.vpc.awsVpcId,
    vpcCidrBlock   = module.vpc.awsVpcCidr,
    mgmtSubnets    = module.vpc.awsManagementSubnets,
    publicSubnets  = module.vpc.awsPublicSubnets,
    privateSubnets = module.vpc.awsPrivateSubnets
  }
}