locals {
  controller = {
    private_dns = module.nginx-controller.controller.private_dns
    private_ip  = module.nginx-controller.controller.private_ip
    public_dns  = module.nginx-controller.controller.public_dns
    public_ip   = module.nginx-controller.controller.public_ip
  }
}

output "controller" {
  value = local.controller
}
