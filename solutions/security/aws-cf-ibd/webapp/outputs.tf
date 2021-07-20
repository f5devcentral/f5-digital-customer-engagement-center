output "asg" {
  value = module.webApp.asg
}

output "alb" {
  value = module.webApp.alb
}

output "albDnsName" {
  value = module.webApp.albDnsName
}
output "vpc" {
  value = module.vpc
}
