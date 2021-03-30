# Description
Ubuntu webserver (Docker host with juiceshop app)
## Usage example

Here's the gist of using it directly from github.

```hcl
module "webApp" {
  source        = "../"
  projectPrefix = var.projectPrefix
  resourceOwner = var.resourceOwner
  vpc           = module.aws_network.vpcs["main"]
  keyName       = aws_key_pair.deployer.id
  mgmtSubnet    = module.aws_network.subnetsAz1["mgmt"]
  securityGroup = aws_security_group.secGroupWebapp.id
}
```

## Assumptions

## Available features

Ubuntu version 20 with docker installed, choose which container to run on it using the 'startupCommand' var

## Requirements

No requirements.

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
| albSubnets | List of subnet ids in which to deploy the alb | `list` | `null` | no |
| associatePublicIp | choose if you want to associate a public ip to the instance | `bool` | `false` | no |
| desiredCapacity | Desired number of server instances | `number` | `1` | no |
| extraTags | Map of additional tags | `map` | <pre>{<br>  "AdditionalKey": "additionalValue"<br>}</pre> | no |
| instanceType | AWS instance type | `string` | `"t3.large"` | no |
| keyName | instance key pair name | `string` | `null` | no |
| projectPrefix | Prefix used in tags to identify the project | `string` | `"f5-dcec"` | no |
| resourceOwner | tag used to mark instance owner | `string` | `"f5-dcec-user"` | no |
| securityGroup | security group id that will be associated with the server | `string` | `null` | no |
| startupCommand | Command to run at boot, used to start the app | `string` | `"docker run -d --restart always -p 80:3000 bkimminich/juice-shop"` | no |
| subnets | List of subnet ids in which to deploy the server/s | `list` | `null` | no |
| vpc | Vpc id in which to deploy the server | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| alb | alb outputs, see https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/latest for details |
| albDnsName | DNS name for the ALB |
| asg | asg outputs, see https://registry.terraform.io/modules/terraform-aws-modules/autoscaling/aws/latest for details |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## How to Contribute

Submit a pull request

# Authors
Yossi rosenboim
