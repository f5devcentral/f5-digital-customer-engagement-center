# Description
ingress-egress and inter-vpc firewall in AWS using AFM and GWLB

## Diagram

![ingress-egress firewall to a single VPC using GWLB](ingress-egress-inter-vpc-fw.png)

## Usage example

- Set AWS environment variables
```bash
export AWS_ACCESS_KEY_ID="dfsafsa"
export AWS_SECRET_ACCESS_KEY="fdsafds"
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

using your ssh key, connect to the Internet Vpc Jumphost - internetVpcData (workspaceManagementAddress)

```bash
ssh ubuntu@x.y.z.p
```

connect to BIGIP, install the required version and complete the setup:

1. Configure a Geneve tunnel
2. Create a 'fake_self_ip' 10.131.0.1/24, assign it to the tunnel interface
3. Create a static arp entry to 10.131.0.2 ff:ff:ff:ff:ff:ff
4. Create a pool with 10.131.0.2 as the member
5. Configure a virtual server performance L4, transparent virtual server, assign the pool from previous step.
6. Configure AFM on the virtual server
7. connect to the internet jumphost 
8. ssh from it to one of the spoke jumphosts 
9. monitor the traffic in AFM 



## Clenaup
use the following command to destroy all of the resources 

```bash
ssh ubuntu@x.y.z.p
```
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
