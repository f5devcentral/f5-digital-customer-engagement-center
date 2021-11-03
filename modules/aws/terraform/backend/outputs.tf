# output "workspaceManagementAddress" {
#   # Result is a map from instance id to private IP address, such as:
#   #  {"i-1234" = "192.168.1.2", "i-5678" = "192.168.1.5"}
#   value = {
#     for instance in aws_instance.workstation:
#     instance.id => "ssh@${aws_instance.workstation.public_ip}"
#   }
# }
output "workspaceManagementAddress" {
  description = "public or private ip address of the instance"
  value       = var.associateEIP ? aws_instance.workstation.public_ip : aws_instance.workstation.private_ip
}

output "workstation" {
  description = "ec2 instance output paramaters as documented here: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance"
  value       = aws_instance.workstation
}
