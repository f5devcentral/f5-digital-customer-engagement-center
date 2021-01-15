// output "eks_config" {
//   value = try(module.aws.kubeconfig)
// }
output "jumphostPublicIp" {
  description = "public ip of linux jumphost"
  value       = module.aws_network.jumphostPublicIp
}
