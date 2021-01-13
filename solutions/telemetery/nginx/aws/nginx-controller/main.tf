

//provider
provider "aws" {
  region = var.aws_region
}
// Network
module "aws_network" {
  source     = "../../../../../infrastucture/aws/terraform/network/min"
  project    = "infra"
  aws_region = var.aws_region
  aws_az1    = var.aws_az1
  aws_az2    = var.aws_az2
  random_id  = random_id.random-string.dec
}
// bucket
// https://github.com/terraform-aws-modules/terraform-aws-s3-bucket
module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "${var.prefix}-bucket-${random_id.random-string.hex}"
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
module "nginx-controller" {
  source            = "../../../../../infrastucture/aws/terraform/nginx-controller"
  vpc               = module.aws_network.vpcs["main"]
  subnet            = module.aws_network.subnets["private"]
  securityGroup     = aws_security_group.controller
  random_id         = random_id.random-string.dec
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
//NGINX
module "nginx" {
  source           = "../../../../../infrastucture/aws/terraform/nginx-plus"
  vpc              = module.aws_network.vpcs["main"]
  subnet           = module.aws_network.subnets["private"]
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

# nginx-plus2
