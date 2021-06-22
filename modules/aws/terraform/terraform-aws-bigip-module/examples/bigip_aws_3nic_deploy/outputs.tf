# BIG-IP Management Public IP Addresses
output mgmtPublicIP {
  value = module.bigip.*.mgmtPublicIP
}

# BIG-IP Management Public DNS Address
output mgmtPublicDNS {
  value = module.bigip.*.mgmtPublicDNS
}

# BIG-IP Management Port
output mgmtPort {
  value = module.bigip.*.mgmtPort
}

# BIG-IP Username
output f5_username {
  value = module.bigip.*.f5_username
}

# BIG-IP Password
output bigip_password {
  value = module.bigip.*.bigip_password
}

output mgmtPublicURL {
  description = "mgmtPublicURL"
  value       = [for i in range(var.instance_count) : format("https://%s:%s", module.bigip[i].mgmtPublicDNS[0], module.bigip[i].mgmtPort)]
}

# VPC ID used for BIG-IP Deploy
output vpc_id {
  value = module.vpc.vpc_id
}

output private_addresses {
  description = "List of BIG-IP private addresses"
  value       = module.bigip.*.private_addresses
}

output public_addresses {
  description = "List of BIG-IP public addresses"
  value       = module.bigip.*.public_addresses
}
