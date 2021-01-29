# Description
Ubuntu workstation
## Usage example

Here's the gist of using it directly from github.

```hcl
module "jumphost" {
  source       = "../../../../../../modules/aws/terraform/workstation"
  project      = "projectName"
  userId       = "someUsername"
  vpc          = "someVpcId"
  keyName      = "EC2_KEY_NAME"
}
```

## Assumptions

## Available features

Ubuntu version 20, sercurity group
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| keyName | EC2 key pair name | `string` | n/a | yes |
| vpc | vpc in which to deploy the instance | `any` | n/a | yes |
| mgmtSubnet | subnet in which to deploy the instance | `string` | n/a | yes |
| project | n/a | `string` | f5-dcec | no |
| instanceType | AWS instance type | `string` | t3.large | no |
| repositories | comma seperated list of git repositories to clone | `string` | `"https://github.com/vinnie357/aws-tf-workspace.git,https://github.com/f5devcentral/terraform-aws-f5-sca.git"` | no |
| securityGroup | security group for the instance | `string` | the module will create one with port 22 and 5800 open to 0.0.0.0/0 | no |
| userId | user name for tagging | `string` | f5-dcec-user | no |


## Outputs

| Name | Description |
|------|-------------|
| workspaceManagementAddress | public ip address of the instance |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## How to Contribute

Submit a pull request

# Authors
Vinnie Mazza

Yossi rosenboim
