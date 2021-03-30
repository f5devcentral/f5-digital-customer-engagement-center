# Description
Ubuntu webserver (Docker host with juiceshop app)
## Usage example

Here's the gist of using it directly from github.

```hcl
module "webServer" {
  source              = "../../../../../../modules/aws/terraform/workstation"
  projectPrefix       = "projectPrefixName"
  resourceOwner       = "someUsername"
  vpc                 = "someVpcId"
  keyName             = "EC2_KEY_NAME"
}
```

## Assumptions

## Available features

Ubuntu version 20 with docker installed, choose which container to run on it using the 'startupCommand' var

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
| associateEIP | choose if you want to associate an EIP to the instance | `bool` | `true` | no |
| instanceType | AWS instance type | `string` | `"t3.large"` | no |
| keyName | instance key pair name | `string` | `null` | no |
| mgmtSubnet | subnet id in which to deploy the server | `string` | `null` | no |
| projectPrefix | Prefix used in tags to identify the project | `string` | `"f5-dcec"` | no |
| resourceOwner | tag used to mark instance owner | `string` | `"f5-dcec-user"` | no |
| securityGroup | security group id that will be associated with the server | `string` | `null` | no |
| startupCommand | Command to run at boot, used to start the app | `string` | `"docker run -d --restart always -p 80:3000 bkimminich/juice-shop"` | no |
| vpc | Vpc id in which to deploy the server | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| workspaceManagementAddress | public or private ip address of the instance |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## How to Contribute

Submit a pull request

# Authors
Yossi rosenboim
