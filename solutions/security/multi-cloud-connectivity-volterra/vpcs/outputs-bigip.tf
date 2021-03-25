output mgmtPublicIP {
  value = module.bigip.*.mgmtPublicIP
}

# BIG-IP Username
output f5Username {
  value = module.bigip.*.f5_username
}

# BIG-IP Password
output bigipPassword {
  value = module.bigip.*.bigip_password
}
output bigipPrivateIp {
  value = module.bigip.*.mgmtPrivateIP[0][0]
}
