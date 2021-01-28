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

Ubuntu version 20
## Module Variables

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
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
| instanceType | n/a | `string` | `"t3.large"` | no |
| keyName | n/a | `any` | n/a | yes |
| mgmtSubnet | n/a | `any` | n/a | yes |
| onboardScript | URL to userdata onboard script | `string` | `"https://raw.githubusercontent.com/vinnie357/workspace-onboard-bash-templates/master/terraform/aws/sca/onboard.sh"` | no |
| project | n/a | `string` | `"f5-dcec"` | no |
| repositories | comma seperated list of git repositories to clone | `string` | `"https://github.com/vinnie357/aws-tf-workspace.git,https://github.com/f5devcentral/terraform-aws-f5-sca.git"` | no |
| securityGroup | n/a | `any` | `null` | no |
| userId | n/a | `string` | `"f5-dcec-user"` | no |
| vpc | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| workspaceManagementAddress | output "workspaceManagementAddress" { # Result is a map from instance id to private IP address, such as: #  {"i-1234" = "192.168.1.2", "i-5678" = "192.168.1.5"} value = { for instance in aws\_instance.workstation: instance.id => "ssh@${aws\_instance.workstation.public\_ip}" } } |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->



## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## How to Contribute

Submit a pull request

# Authors
Vinnie Mazza

Yossi rosenboim

### Terraform Registry
