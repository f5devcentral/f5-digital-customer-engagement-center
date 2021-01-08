provider "aws" {
  region = var.aws_region
}
// Network
module "aws_network" {
  source       = "../../../../../../infrastucture/aws/terraform/network/min"
  project      = "infra"
  aws_region   = var.aws_region
  aws_az1      = var.aws_az1
  aws_az2      = var.aws_az2
  random_id    = random_id.random-string.dec
  cluster_name = "${var.cluster_name}-${random_id.random-string.dec}"
}


// NGINX
// module nginx {
//   source = "./nginx"
//   vpc = module.infa.vpc_nginx.id
//   subnets = [module.infa.subnet1.id, modules.ifra.subnet2.id]
//   admin
//   sshpubkey
//   nginxconf /conf.d/
//   targetapp ip?
//   machinesize

// }

// module nginx2 {
//   source = "./nginx"
//   vpc = module.infa.vpc_nginx.id
//   subnets = [module.infa.subnet1.id, modules.ifra.subnet2.id]
//   admin
//   sshpubkey
//   nginxconf /conf.d/
//   targetapp ip?
//   machinesize

// }
