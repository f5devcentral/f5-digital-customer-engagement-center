provider "aws" {
  region = var.aws_region
}
// Network
module "aws_network" {
  source     = "../../../../../../modules/aws/terraform/network/min"
  project    = "infra"
  aws_region = var.aws_region
  aws_az1    = var.aws_az1
  aws_az2    = var.aws_az2
  random_id  = random_id.random-string.dec
}


//NGINX
module "nginx" {
  source           = "../../../../../../modules/aws/terraform/nginx-plus"
  aws_region       = var.aws_region
  vpc              = module.aws_network.vpcs["main"]
  subnet           = module.aws_network.subnets["private"]
  securityGroup    = aws_security_group.nginx
  nginxCert        = var.nginxCert
  nginxKey         = var.nginxKey
  adminAccountName = var.adminAccountName
  ec2KeyName       = var.ec2KeyName
  sshPublicKey     = var.sshPublicKey
  #sshPublicKey     = file("/home/user/mykey.pub")
  controllerAddress = "none"
  controllerAccount = "none"
  controllerPass    = "none"
}

// //NGINX
// module "nginx2" {
//   source           = "../../../../../../modules/aws/terraform/nginx-plus"
//   vpc              = module.aws_network.vpcs["main"]
//   subnet           = module.aws_network.subnets["public"]
//   securityGroup    = aws_security_group.nginx
//   nginxCert        = "mycert"
//   nginxKey         = "mykey"
//   adminAccountName = "xadmin"
//   ec2KeyName       = "myec2key"
//   sshPublicKey     = "mykeyName"
//   #sshPublicKey     = file("/home/user/mykey.pub")
// }
