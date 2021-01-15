# terraform-aws-f5lab-network-module


## Usage example

Here's the gist of using it directly from github.

```hcl
module "aws_network" {
  source       = "../../../../../../infrastucture/aws/terraform/network/min"
  project      = "kic-aws"
  userId       = var.userId
  awsRegion    = var.awsRegion
  awsAz1       = var.awsAz1
  awsAz2       = var.awsAz2
  sshPublicKey = var.sshPublicKey
}
```

## Assumptions

## Available features

vpc, subnets, routing tables, jumphost
## Module Variables

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
| awsAz1 | n/a | `string` | `"us-east-1a"` | no |
| awsAz2 | n/a | `string` | `"us-east-1b"` | no |
| awsRegion | n/a | `string` | `"us-east-1"` | no |
| jumphostInstanceType | n/a | `string` | `"t3.large"` | no |
| project | project name to use for tags | `string` | `"f5-dcec"` | no |
| sshPublicKey | n/a | `string` | `"ssh-rsa AAAAB3Nza..."` | no |
| userId | owner of the deployment, for tagging purposes | `string` | `"f5-dcec"` | no |

## Outputs

| Name | Description |
|------|-------------|
| jumphostPublicIp | n/a |
| securityGroups | security groups |
| subnetsAz1 | n/a |
| subnetsAz2 | n/a |
| vpcs | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Commands

<!-- START makefile-doc -->
```
$ make help
hooks                          Commit hooks setup
validate                       Validate with pre-commit hooks
changelog                      Update changelog
release                        Create release version
```
<!-- END makefile-doc -->


### :memo: Guidelines

 - :memo: Use a succinct title and description.
 - :bug: Bugs & feature requests can be be opened
 - :signal_strength: Support questions are better asked on [Stack Overflow](https://stackoverflow.com/)
 - :blush: Be nice, civil and polite ([as always](http://contributor-covenant.org/version/1/4/)).

## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## How to Contribute

Submit a pull request

# Authors


## Terraform Registry
