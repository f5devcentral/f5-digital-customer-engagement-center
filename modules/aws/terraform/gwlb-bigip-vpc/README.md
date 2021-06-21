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
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allowedMgmtIps | n/a | `list` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| awsAz1 | will use a dynamic az if left empty | `any` | `null` | no |
| awsAz2 | will use a dynamic az if left empty | `any` | `null` | no |
| bigipInstanceCount | number of BIGIP devices to deploy | `number` | `2` | no |
| buildSuffix | random build suffix for tagging | `string` | `"f5-dcec"` | no |
| createGwlbEndpoint | Controls the creation of gwlb endpoints in the provided vpc, if true creates subnets and endpoints | `bool` | `false` | no |
| customUserData | content of a file containing custom user data for the BIGIP instance | `any` | `null` | no |
| keyName | n/a | `any` | `null` | no |
| projectPrefix | projectPrefix name to use for tags | `string` | `"f5-dcec"` | no |
| resourceOwner | owner of the deployment, for tagging purposes | `string` | `"f5-dcec"` | no |
| subnetGwlbeAz1 | n/a | `string` | `"10.252.54.0/24"` | no |
| subnetGwlbeAz2 | n/a | `string` | `"10.252.154.0/24"` | no |
| vpcCidr | n/a | `string` | `"10.252.0.0/16"` | no |
| vpcGwlbSubPubACidr | n/a | `string` | `"10.252.10.0/24"` | no |
| vpcGwlbSubPubBCidr | n/a | `string` | `"10.252.110.0/24"` | no |

## Outputs

| Name | Description |
|------|-------------|
| bigipInstanceId | n/a |
| bigipIp | n/a |
| bigipPassword | n/a |
| gwlbEndpointService | n/a |
| gwlbeAz1 | Id of the GWLB endpoint in AZ1 |
| gwlbeAz2 | Id of the GWLB endpoint in AZ2 |
| subnetGwlbeAz1 | n/a |
| subnetGwlbeAz2 | n/a |
| subnetsAz1 | n/a |
| subnetsAz2 | n/a |
| vpcs | n/a |

## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## How to Contribute

Submit a pull request

# Authors
Yossi rosenboim

### Terraform Registry
