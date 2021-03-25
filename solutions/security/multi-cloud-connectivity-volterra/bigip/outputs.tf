output mgmtPublicIP {
  value = module.bigip.*.mgmtPublicIP
}

# BIG-IP Username
output f5_username {
  value = module.bigip.*.f5_username
}

# BIG-IP Password
output bigip_password {
  value = module.bigip.*.bigip_password
}
