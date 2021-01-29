# Description
VPC with GWLB and 2 inspection devices

## Diagram

![gwlb-bigip-vpc](gwlb-bigip-vpc.png)
## Usage example

quick example

```hcl
module "gwlb-bigip-vpc" {
  source        = "../../../modules/aws/terraform/gwlb-bigip-vpc"
  project       = "some project name"
  userId        = "some user name"
  awsRegion     = "us-west-2"
  keyName       = "ec2_key_name"
}
```

## Available features

vpc, GWLB, GENEVE proxies with FW rules, GWLB endpoint ## Requirements
## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| keyName | EC2 key_pair name | `string` | `null` | yes |
| allowedMgmtIps | list of cidr's that can access FW management | `list` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| awsAz1 | will use a dynamic az if left empty | `string` | `null` | no |
| awsAz2 | will use a dynamic az if left empty | `string` | `null` | no |
| awsRegion | n/a | `string` | us-west-2 | no |
| project | project name to use for tags | `string` | f5-dcec | no |
| userId | owner of the deployment, for tagging purposes | `string` | f5-dcec | no |
| vpcCidr | cidr range for the vpc | `string` | 10.252.0.0/16 | no |
| vpcGwlbSubPubACidr | cidr range for the vpcGwlbSubPubA | `string` | 10.252.10.0/24 | no |
| vpcGwlbSubPubBCidr | cidr range for the vpcGwlbSubPubB | `string` | 10.252.110.0/24 | no |

## Outputs

| Name | Description |
|------|-------------|
| geneveProxyIpAz1 | public ip of the GENEVE proxy |
| geneveProxyIpAz2 | public ip of the GENEVE proxy |
| gwlbEndpointService | endpoint service name to be used by consumers of the FW service |
| subnetsAz1 | dictionary of subnets in Az1 |
| subnetsAz2 | dictionary of subnets in Az2 |
| vpcs | dictionary of vpc's |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

### :memo: Guidelines


## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## How to Contribute

Submit a pull request

# Authors
Yossi rosenboim

### Terraform Registry
