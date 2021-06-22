# Description
VPC with GWLB and a fixed number of BIGIP's
currently all BIGIP's will be deployed to az1

## Diagram

![gwlb-bigip-vpc](gwlb-bigip-vpc.png)
## Usage example

quick example

```hcl
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
  source        = "../"
  projectPrefix = var.projectPrefix
  resourceOwner = var.resourceOwner
  keyName       = aws_key_pair.deployer.id
  buildSuffix   = random_id.buildSuffix.hex
  instanceCount = 1
  createGwlbEndpoint = true
  customUserData = data.local_file.customUserData.content
}
```

## Available features

vpc, GWLB, BIGIP's , GWLB endpoint ## Requirements

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
