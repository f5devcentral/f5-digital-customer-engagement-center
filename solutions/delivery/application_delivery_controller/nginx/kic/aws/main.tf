provider "aws" {
  region = var.aws_region
}
// module "aws" {
//   source = "git::https://github.com/f5devcentral/terraform-aws-f5-sca//modules/awsInfrastructure/?ref=master"
//   project = "infra"
//   cidr-1 = "10.100.0.0/16"
//   cidr-2 = "10.200.0.0/16"
//   cidr-3 = "10.240.0.0/16"
//   aws_region = var.aws_region
//   region-az-1 = var.aws_az
//   region-az-2 = var.aws_az1
// }

// module "aws_network" {
//   source      = "../../../../../infrastucture/aws/terraform/network/max"
//   project     = "infra"
//   aws_region  = var.aws_region
//   aws_az1 = var.aws_az
//   aws_az2 = var.aws_az1
// }
module "aws_network" {
  source       = "../../../../../../infrastucture/aws/terraform/network/min"
  project      = "infra"
  aws_region   = var.aws_region
  aws_az1      = var.aws_az1
  aws_az2      = var.aws_az2
  random_id    = random_id.random-string.dec
  cluster_name = "${var.cluster_name}-${random_id.random-string.dec}"
}
// eks
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "${var.cluster_name}-${random_id.random-string.dec}"
  cluster_version = "1.18"
  subnets         = [module.aws_network.subnets["private"], module.aws_network.subnets["public"]]
  vpc_id          = module.aws_network.vpcs["main"]
  worker_groups = [
    {
      instance_type = "t3.xlarge"
      asg_max_size  = 4
    }
  ]
  create_eks                           = true
  manage_aws_auth                      = true
  write_kubeconfig                     = true
  cluster_endpoint_private_access      = false
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = [var.admin_source_cidr]
  config_output_path                   = "${path.module}/cluster-config"
}


// module nginx {
//   source = "./nginx"
//   vpc = module.infa.vpc_nginx.id
//   subnets = [module.infa.subnet1.id, modules.ifra.subnet2.id]
//   admin_cidr

// }

// module controller {
//   vpc = module.infa.vpc_controller.id
//   subnets = [module.infa.subnet1.id, modules.]
// }
