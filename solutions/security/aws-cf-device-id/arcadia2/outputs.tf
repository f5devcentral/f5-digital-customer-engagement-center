output "kubernetesClusterName" {
  value = module.eks.cluster_id
}

output "publicSubnetAZ1" {
  value = module.aws_network.subnetsAz1.public
}

output "publicSubnetAZ2" {
  value = module.aws_network.subnetsAz2.public
}
