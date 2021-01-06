locals {
  vpcs = {
    "main" = aws_vpc.main.id
    // "security" = aws_vpc.security.id
  }
}

output "kubeconfig" {
  value = try(module.eks.kubeconfig, "none")
}
output "vpcs" {
  value = local.vpcs
}

output "aws_eks_cluster" {
  value = data.aws_eks_cluster.cluster[*]
}

output "aws_eks_cluster_auth" {
  value = data.aws_eks_cluster_auth.cluster[*]
}
