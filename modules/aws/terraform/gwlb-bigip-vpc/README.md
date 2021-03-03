# Description
VPC with GWLB and 2 inspection devices

## Diagram

![gwlb-bigip-vpc](gwlb-bigip-vpc.png)
## Usage example

quick example

```hcl
module "gwlb-bigip-vpc" {
  source        = "../../../modules/aws/terraform/gwlb-bigip-vpc"
  projectPrefix       = "some projectPrefix name"
  resourceOwner        = "some user name"
  awsRegion     = "us-west-2"
  keyName       = "ec2_key_name"
}
```

## Available features

vpc, GWLB, GENEVE proxies with FW rules, GWLB endpoint ## Requirements

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| null | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allowedMgmtIps | n/a | `list` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| awsAz1 | will use a dynamic az if left empty | `any` | `null` | no |
| awsAz2 | will use a dynamic az if left empty | `any` | `null` | no |
| bigipPassword | password for the bigip admin account | `any` | `null` | no |
| buildSuffix | random build suffix for tagging | `string` | `"f5-dcec"` | no |
| createGwlbEndpoint | Controls the creation of gwlb endpoints in the provided vpc, if true creates subnets and endpoints | `bool` | `false` | no |
| instanceCount | n/a | `number` | `1` | no |
| keyName | n/a | `any` | `null` | no |
| projectPrefix | projectPrefix name to use for tags | `string` | `"f5-dcec"` | no |
| repositories | comma seperated list of git repositories to clone | `string` | `"https://github.com/vinnie357/aws-tf-workspace.git,https://github.com/f5devcentral/terraform-aws-f5-sca.git"` | no |
| resourceOwner | owner of the deployment, for tagging purposes | `string` | `"f5-dcec"` | no |
| subnetGwlbeAz1 | n/a | `string` | `"10.252.54.0/24"` | no |
| subnetGwlbeAz2 | n/a | `string` | `"10.252.154.0/24"` | no |
| vpcCidr | n/a | `string` | `"10.252.0.0/16"` | no |
| vpcGwlbSubPubACidr | n/a | `string` | `"10.252.10.0/24"` | no |
| vpcGwlbSubPubBCidr | n/a | `string` | `"10.252.110.0/24"` | no |

## Outputs

| Name | Description |
|------|-------------|
| bigipAz1Ip | n/a |
| bigipPassword | n/a |
| gwlbEndpointService | n/a |
| gwlbeAz1 | Id of the GWLB endpoint in AZ1 |
| gwlbeAz2 | Id of the GWLB endpoint in AZ2 |
| subnetGwlbeAz1 | n/a |
| subnetGwlbeAz2 | n/a |
| subnetsAz1 | n/a |
| subnetsAz2 | n/a |
| vpcs | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

### :memo: Guidelines


## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## How to Contribute

Submit a pull request

# Authors
Yossi rosenboim

### Terraform Registry
