output "student1" {
  value = module.jumphost_1.workstation.0.network_interface.0.access_config.0.nat_ip
}
output "student2" {
  value = module.jumphost_2.workstation.0.network_interface.0.access_config.0.nat_ip
}
output "student3" {
  value = module.jumphost_3.workstation.0.network_interface.0.access_config.0.nat_ip
}
output "coderAccountPassword" {
  value = random_password.password.result
}
