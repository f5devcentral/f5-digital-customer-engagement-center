

//provider
provider "aws" {
  region = var.awsRegion
}
// Network
module "aws_network" {
  source                  = "../../../../../modules/aws/terraform/network/min"
  projectPrefix           = var.projectPrefix
  awsRegion               = var.awsRegion
  map_public_ip_on_launch = true
  resourceOwner           = var.resourceOwner
}
// bucket
// https://github.com/terraform-aws-modules/terraform-aws-s3-bucket
module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "${var.projectPrefix}-bucket-${random_id.randomString.hex}"
  acl    = "private"

  versioning = {
    enabled = true
  }

}
resource "aws_s3_bucket_object" "controllerFile" {
  bucket = module.s3_bucket.this_s3_bucket_id
  key    = var.controller_install_file_name
  source = "${path.module}/${var.controller_install_file_name}"
}
// controller
#https://docs.nginx.com/nginx-controller/admin-guides/install/nginx-controller-tech-specs/#aws-ebs
module "nginx-controller" {
  source            = "../../../../../modules/aws/terraform/nginx-controller"
  vpc               = module.aws_network.vpcs["main"]
  subnet            = module.aws_network.subnetsAz1["public"]
  resourceOwner     = var.resourceOwner
  securityGroup     = aws_security_group.controller
  random_id         = random_id.randomString.dec
  controllerAccount = var.controllerAccount
  controllerPass    = var.controllerPass
  controllerLicense = var.controllerLicense
  dbuser            = var.dbuser
  dbpass            = var.dbpass
  ec2KeyName        = var.ec2KeyName
  sshPublicKey      = var.sshPublicKey
  bucketId          = module.s3_bucket.this_s3_bucket_id
  bucketFileId      = aws_s3_bucket_object.controllerFile.id
  #sshPublicKey     = file("/home/user/mykey.pub")
}
//NGINX-plus1
module "nginx" {
  source           = "../../../../../modules/aws/terraform/nginx-plus"
  aws_region       = var.awsRegion
  vpc              = module.aws_network.vpcs["main"]
  subnet           = module.aws_network.subnetsAz1["public"]
  securityGroup    = aws_security_group.nginx
  nginxCert        = var.nginxCert
  nginxKey         = var.nginxKey
  adminAccountName = var.adminAccountName
  ec2KeyName       = var.ec2KeyName
  sshPublicKey     = var.sshPublicKey
  #sshPublicKey     = file("/home/user/mykey.pub")
  controllerAddress = module.nginx-controller.controller.private_ip
  controllerAccount = var.controllerAccount
  controllerPass    = var.controllerPass
}

# NGINX-plus2
module "nginx2" {
  source           = "../../../../../modules/aws/terraform/nginx-plus"
  aws_region       = var.awsRegion
  vpc              = module.aws_network.vpcs["main"]
  subnet           = module.aws_network.subnetsAz2["public"]
  securityGroup    = aws_security_group.nginx
  nginxCert        = var.nginxCert
  nginxKey         = var.nginxKey
  adminAccountName = var.adminAccountName
  ec2KeyName       = var.ec2KeyName
  sshPublicKey     = var.sshPublicKey
  #sshPublicKey     = file("/home/user/mykey.pub")
  controllerAddress = module.nginx-controller.controller.private_ip
  controllerAccount = var.controllerAccount
  controllerPass    = var.controllerPass
}
