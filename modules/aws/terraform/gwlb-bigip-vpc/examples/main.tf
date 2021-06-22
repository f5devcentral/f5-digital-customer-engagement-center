provider "aws" {
  region = var.awsRegion
}

data "local_file" "customUserData" {
  filename = "${path.module}/f5_onboard.tmpl"
}
resource "aws_key_pair" "deployer" {
  key_name   = "${var.projectPrefix}-key-${random_id.buildSuffix.hex}"
  public_key = var.sshPublicKey
}

module "gwlb-bigip-vpc" {
  source             = "../"
  projectPrefix      = var.projectPrefix
  resourceOwner      = var.resourceOwner
  keyName            = aws_key_pair.deployer.id
  buildSuffix        = random_id.buildSuffix.hex
  createGwlbEndpoint = true
  customUserData     = data.local_file.customUserData.content
  bigipInstanceCount = 2
}
