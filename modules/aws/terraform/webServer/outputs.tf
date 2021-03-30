output "asg" {
  description = "asg outputs, see https://registry.terraform.io/modules/terraform-aws-modules/autoscaling/aws/latest for details"
  value       = module.asg
}
output "alb" {
  description = "alb outputs, see https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/latest for details"
  value       = module.alb
}

output "albDnsName" {
  description = "DNS name for the ALB"
  value       = module.alb.this_lb_dns_name
}