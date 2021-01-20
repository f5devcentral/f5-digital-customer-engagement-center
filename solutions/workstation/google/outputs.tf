output "workstation" {
  value = module.jumphost.workstation.0.network_interface.0.access_config.0.nat_ip
}
