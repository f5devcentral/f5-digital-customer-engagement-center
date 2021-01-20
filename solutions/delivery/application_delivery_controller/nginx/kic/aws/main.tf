provider "aws" {
  region = var.awsRegion
}
//   source = "git::https://github.com/f5devcentral/f5-digital-customer-engagement-center//infrastructure/aws/network/max/?ref=main"
// module "aws_network" {
//   source      = "../../../../../modules/aws/terraform/network/max"
//   project     = "infra"
//   aws_region  = var.aws_region
//   aws_az1 = var.aws_az
//   aws_az2 = var.aws_az1
// }
// Network
module "aws_network" {
  source       = "../../../../../../modules/aws/terraform/network/min"
  project      = "kic-aws"
  userId       = var.userId
  awsRegion    = var.awsRegion
  awsAz1       = var.awsAz1
  awsAz2       = var.awsAz2
  sshPublicKey = var.sshPublicKey
}
// EKS
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
  cluster_name    = "${var.clusterName}-${random_id.randomString.dec}"
  cluster_version = "1.18"
  subnets         = [module.aws_network.subnetsAz2["public"], module.aws_network.subnetsAz1["public"]]
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
  cluster_endpoint_public_access_cidrs = [var.adminSourceCidr]
  config_output_path                   = "${path.module}/cluster-config"
}





// NGINX
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
