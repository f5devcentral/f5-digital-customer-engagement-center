provider "aws" {
  region = var.awsRegion
}

// Network
module "aws_network" {
  source                  = "../../../../modules/aws/terraform/network/min"
  projectPrefix           = var.projectPrefix
  awsRegion               = var.awsRegion
  map_public_ip_on_launch = true
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
  #load_config_file       = false
}
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "${var.clusterName}-${random_id.randomString.dec}"
  cluster_version = "1.18"
  subnets         = [module.aws_network.subnetsAz2["public"], module.aws_network.subnetsAz1["public"]]
  vpc_id          = module.aws_network.vpcs["main"]
  worker_groups = [
    {
      instance_type    = "t3.xlarge"
      asg_max_size     = 4
      root_volume_type = "standard"
    }
  ]
  create_eks                           = true
  manage_aws_auth                      = true
  write_kubeconfig                     = true
  cluster_endpoint_private_access      = false
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = [var.adminSourceCidr]
  kubeconfig_output_path               = "${path.module}/cluster-config"
}

// jumphost
resource "aws_key_pair" "deployer" {
  key_name   = "${var.adminAccountName}-${var.projectPrefix}"
  public_key = var.sshPublicKey
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "my-first-namespace"
  }
}
