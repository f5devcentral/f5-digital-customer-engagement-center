# Description
ingress-egress firewall to a single VPC using GWLB

## Diagram

![ingress-egress firewall to a single VPC using GWLB](gwlb-fw.png)
## Usage example

- Set AWS environment variables
```bash
export AWS_ACCESS_KEY_ID="dfsafsa"
export AWS_SECRET_ACCESS_KEY="fdsafds"
export AWS_SESSION_TOKEN="kgnfdskg"
```

create the vars file and update it with your settings

```bash
cp admin.auto.tfvars.example admin.auto.tfvars
# MODIFY TO YOUR SETTINGS
```

run the setup script to deploy all of the components into your AWS account (remember that you are responsible for the cost of those components)

```bash
./setup.sh
```

## Available features

using your ssh key, connect to the UbuntuJumpHost
```bash
ssh ubuntu@x.y.z.p
```

connect to the two inspection devices and check that you can see the ssh traffic between you and the jumphost
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |


## Outputs

| Name | Description |
|------|-------------|
| geneveProxyAz1Ip | public ip address of the 1st inspection device |
| geneveProxyAz2Ip | public ip address of the 2nd inspection device |
| ubuntuJumpHostAz1 | public ip address of the ubuntu JumpHost in Az1 |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## How to Contribute

Submit a pull request

# Authors
Yossi rosenboim
