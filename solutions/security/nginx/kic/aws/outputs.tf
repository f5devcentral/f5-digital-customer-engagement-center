output "jumphostPublicIp" {
  value = module.jumphost.workspaceManagementAddress
}

output "coderAdminPassword" {
  value = random_password.password.result
}

output "kubernetesClusterName" {
  value = module.eks.cluster_id
}

output "ecrRepositoryURL" {
  value = aws_ecr_repository.ecr.repository_url
}

output "publicSubnetAZ1" {
  value = module.aws_network.subnetsAz1.public
}

output "publicSubnetAZ2" {
  value = module.aws_network.subnetsAz2.public
}
