# Description
ingress-egress firewall to a single VPC using GWLB

## Diagram

![ingress-egress firewall to a single VPC using GWLB](gwlb-fw.png)

![Ingress traffic flow - Follow the packet](ingress-traffic-flow.png)

![Egress traffic flow - Follow the packet](Egress-traffic-flow.png)
## Requirements

- Solution was tested only on us-west-2, the region has to support GWLB.
- Subscribe to the F5 PAYG-Best 1Gbps image from the AWS marketplace - https://aws.amazon.com/marketplace/pp/prodview-atilk7h6dqu6k?ref_=srh_res_product_title

## Usage example

- Set AWS environment variables
```bash
export AWS_ACCESS_KEY_ID="your_key"
export AWS_SECRET_ACCESS_KEY="your_secret_key"
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

## BIGIP configuration steps

Connect to the BIGIP using the bigipPublicIp and bigipPassword over port 8443. https://quickstart:bigipPassword@bigipPublicIp:8443

Username: quickstart

Password: bigipPassword output value

Please note it takes a few minutes for the BIGIP to complete the onboarding process, once it's done you will be able to ssh into the jumphost.

The BIGIP gets configured with a forwarding virtual server to route accept the traffic inside the GENEVE tunnel and apply relevant security controls on it.

Create your AFM policy and logging configuration


## TEST your setup:


using your ssh key, connect to the  Jumphost - ubuntuJumpHostAz1

```bash
ssh ubuntu@x.y.z.p
```

monitor the traffic in AFM, you should see traffic incoming and outgoing from the jumphost in AFM

## Cleanup
use the following command to destroy all of the resources

```bash
./destroy.sh
```

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| adminSourceCidr | cidr range allowed to access the jumpHost | `string` | `"0.0.0.0/0"` | no |
| awsAz1 | Availability zone, will dynamically choose one if left empty | `string` | `null` | no |
| awsAz2 | Availability zone, will dynamically choose one if left empty | `string` | `null` | no |
| awsRegion | aws region | `string` | `"us-east-2"` | no |
| projectPrefix | projectPrefix name for tagging | `string` | `"gwlb-fw"` | no |
| resourceOwner | Owner of the deployment for tagging purposes | `string` | `"elsa"` | no |
| sshPublicKey | SSH public key used to create an EC2 keypair | `string` | `null` | no |
| vpcMainCidr | cidr range for vpcMain | `string` | `"10.1.0.0/16"` | no |
| vpcMainSubGwlbeACidr | cidr range for GWLBE subnet A | `string` | `"10.1.52.0/24"` | no |
| vpcMainSubGwlbeBCidr | cidr range for GWLBE subnet B | `string` | `"10.1.152.0/24"` | no |
| vpcMainSubPubACidr | cidr range for public subnetA | `string` | `"10.1.10.0/24"` | no |
| vpcMainSubPubBCidr | cidr range for public subnetB | `string` | `"10.1.110.0/24"` | no |

## Outputs

| Name | Description |
|------|-------------|
| bigipAz1Ip | public ip address of the BIGIP |
| ubuntuJumpHostAz1 | public ip address of the jumphost |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## How to Contribute

Submit a pull request

# Authors
Yossi rosenboim
