
provider "aws" {
  region = var.awsRegion
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.projectPrefix}-key-${random_id.buildSuffix.hex}"
  public_key = var.sshPublicKey
}

module "gwlb-bigip-vpc" {
  source        = "../"
  projectPrefix = var.projectPrefix
  resourceOwner = var.resourceOwner
  awsRegion     = var.awsRegion
  keyName       = aws_key_pair.deployer.id
  buildSuffix   = random_id.buildSuffix.hex
  instanceCount = 1
}
