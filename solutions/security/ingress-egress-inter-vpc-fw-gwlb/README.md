# Description
ingress-egress and inter-vpc firewall in AWS using AFM and GWLB

## Diagram

![ingress-egress-inter-vpc firewall using GWLB](ingress-egress-inter-vpc-WITH-sec.png)

![Spoke10 to the internet traffic flow](spoke10-to-internet.png)

![Spoke10 to spoke20 traffic flow](spoke10-to-spoke20.png)

![user to spoke10 service traffic flow](user-to-spoke10-service.png)
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

run the terraform plan to deploy all of the components into your AWS account (remember that you are responsible for the cost of those components)

```bash
terraform init
terraform plan
terraform apply
```

## BIGIP configuration steps

Connect to the BIGIP using the bigipPublicIp and bigipPassword over port 8443. https://quickstart:bigipPassword@bigipPublicIp:8443

Username: quickstart

Password: bigipPassword output value

Please note it takes a few minutes for the BIGIP to complete the onboarding process, once it's done you will be able to ssh into the jumphost.

The BIGIP gets configured with a forwarding virtual server to route accept the traffic inside the GENEVE tunnel and apply relevant security controls on it.

Create your AFM policy and logging configuration


## TEST your setup:

SCP your ssh keys to the jumphost (For Testing only, don't use long lived SSH keys)

```bash
scp ~/.ssh/id_rsa ~/.ssh/id_rsa.pub ubuntu@44.230.225.53:~/.ssh/
```

using your ssh key, connect to the Internet Vpc Jumphost - internetVpcData (workspaceManagementAddress)

```bash
ssh ubuntu@x.y.z.p
```

ssh from it to one of the spoke jumphosts (get the private ip from terraform output)

monitor the traffic in AFM

## Cleanup
use the following command to destroy all of the resources

```bash
terraform destroy
```

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.24 |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| awsAz1 | Availability zone, will dynamically choose one if left empty | `string` | `null` | no |
| awsAz2 | Availability zone, will dynamically choose one if left empty | `string` | `null` | no |
| awsRegion | aws region | `string` | `"us-east-2"` | no |
| projectPrefix | projectPrefix name for tagging | `string` | `"fw-inter-vpc"` | no |
| resourceOwner | Owner of the deployment for tagging purposes | `string` | `"elsa"` | no |
| sshPublicKey | SSH public key used to create an EC2 keypair | `string` | `null` | no |
## Outputs

| Name | Description |
|------|-------------|
| bigipPassword | Password for the admin usernmae |
| bigipPublicIp | Public ip for the BIGIP, access on port 8443 |
| jumphostPublicIp | List of public ip's for the jumphosts |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## How to Contribute

Submit a pull request

# Authors
Yossi rosenboim
