// eks
data "aws_eks_cluster" "cluster" {
  count = var.kubernetes ? 1 : 0
  name  = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  count = var.kubernetes ? 1 : 0
  name  = module.eks.cluster_id
}
provider "kubernetes" {
  host                   = element(concat(data.aws_eks_cluster.cluster[*].endpoint, list("")), 0)
  cluster_ca_certificate = base64decode(element(concat(data.aws_eks_cluster.cluster[*].certificate_authority.0.data, list("")), 0))
  token                  = element(concat(data.aws_eks_cluster_auth.cluster[*].token, list("")), 0)
  load_config_file       = false
}
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-cluster-${random_id.random-string.dec}"
  cluster_version = "1.18"
  subnets         = [aws_subnet.private-subnet.id, aws_subnet.public-subnet.id]
  vpc_id          = aws_vpc.main.id
  worker_groups = [
    {
      instance_type = "t3.xlarge"
      asg_max_size  = 4
    }
  ]
  create_eks         = var.kubernetes
  manage_aws_auth    = true
  write_kubeconfig   = false
  config_output_path = "${path.module}/cluster-config"
}
