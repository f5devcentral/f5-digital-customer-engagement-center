# Description
VPC with GWLB and 2 inspection devices

## Diagram

![AWS-single-vpc-network](AWS-single-vpc-network.png)
## Usage example

Here's the gist of using it directly from github.

```hcl
module "aws_network" {
  source       = "../../../../../../modules/aws/terraform/network/min"
  project      = "kic-aws"
  userId       = var.userId
  awsRegion    = var.awsRegion
  sshPublicKey = var.sshPublicKey
}
```

## Assumptions

## Available features

vpc, subnets, routing tables, internet gateway
## Module Variables

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allowedMgmtIps | n/a | `list` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| awsAz1 | n/a | `any` | `null` | no |
| awsAz2 | n/a | `any` | `null` | no |
| awsRegion | n/a | `string` | `"us-east-1"` | no |
| instanceCount | n/a | `number` | `1` | no |
| keyName | n/a | `any` | `null` | no |
| map\_public\_ip\_on\_launch | assigns public ip's to instances in the public subnet by default | `bool` | `false` | no |
| project | project name to use for tags | `string` | `"f5-dcec"` | no |
| userId | owner of the deployment, for tagging purposes | `string` | `"f5-dcec"` | no |

## Outputs

| Name | Description |
|------|-------------|
| account\_id | n/a |
| geneveProxyIp | n/a |
| gwlbEndpointService | n/a |
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
