# Description
Ubuntu workstation
## Usage example

Here's the gist of using it directly from github.

```hcl
module "jumphost" {
  source       = "../../../../../../modules/aws/terraform/workstation"
  projectPrefix      = "projectPrefixName"
  resourceOwner       = "someUsername"
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
| adminAccountName | admin account name used with instance | `any` | `null` | no |
| associateEIP | choose if you want to associate an EIP to the instance | `bool` | `true` | no |
| coderAccountPassword | n/a | `string` | `"pleaseUseVault123!!"` | no |
| instanceType | instance | `string` | `"t3.large"` | no |
| keyName | instance key pair name | `any` | n/a | yes |
| mgmtSubnet | n/a | `any` | n/a | yes |
| onboardScript | URL to userdata onboard script | `string` | `"https://raw.githubusercontent.com/vinnie357/workspace-onboard-bash-templates/master/terraform/aws/sca/onboard.sh"` | no |
| projectPrefix | project | `string` | `"f5-dcec"` | no |
| repositories | comma seperated list of git repositories to clone | `string` | `"https://github.com/vinnie357/aws-tf-workspace.git,https://github.com/f5devcentral/terraform-aws-f5-sca.git"` | no |
| resourceOwner | tag used to mark instance owner | `string` | `"f5-dcec-user"` | no |
| securityGroup | n/a | `any` | `null` | no |
| terraformVersion | n/a | `string` | `"0.14.0"` | no |
| vpc | network | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| workspaceManagementAddress | public or private ip address of the instance |
| workstation | ec2 instance output paramaters as documented here: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## How to Contribute

Submit a pull request

# Authors
Vinnie Mazza

Yossi rosenboim
