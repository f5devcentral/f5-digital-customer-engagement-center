output "student" {
  value = module.jumphost[*].workstation.0.network_interface.0.access_config.0.nat_ip
}
output "coderAccountPassword" {
  value = random_password.password.result
}
