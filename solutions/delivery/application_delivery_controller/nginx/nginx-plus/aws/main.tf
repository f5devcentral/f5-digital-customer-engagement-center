provider "aws" {
  region = var.aws_region
}
// Network
module "aws_network" {
  source     = "../../../../../../infrastucture/aws/terraform/network/min"
  project    = "infra"
  aws_region = var.aws_region
  aws_az1    = var.aws_az1
  aws_az2    = var.aws_az2
  random_id  = random_id.random-string.dec
}


//NGINX
module "nginx" {
  source           = "../../../../../../infrastucture/aws/terraform/nginx-plus"
  vpc              = module.aws_network.vpcs["main"]
  subnet           = module.aws_network.subnets["private"]
  securityGroup    = aws_security_group.nginx
  nginxCert        = "mycert"
  nginxKey         = "mykey"
  adminAccountName = "xadmin"
  ec2KeyName       = "myec2key"
  sshPublicKey     = "mykeyName"
  #sshPublicKey     = file("/home/user/mykey.pub")
}

// //NGINX
// module "nginx2" {
//   source           = "../../../../../../infrastucture/aws/terraform/nginx-plus"
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
