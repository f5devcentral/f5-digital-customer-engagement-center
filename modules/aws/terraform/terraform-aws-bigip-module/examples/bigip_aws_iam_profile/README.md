## Deploys F5 BIG-IP AWS Cloud

This Terraform module deploys 1-NIC BIG-IP in AWS and by using module count feature we can also deploy multiple BIGIP instances(default value of count as 1 ) with the following characteristics:

BIG-IP 1 Nic as management interface associated with user provided subnet and security-group


## Steps to clone and use the provisioner locally

```
$ git clone https://github.com/f5devcentral/terraform-aws-bigip-module
$ cd terraform-aws-bigip-module/examples/bigip_aws_1nic_deploy/

```

- Then follow the stated process in Example Usage below

## Example Usage

>Modify terraform.tfvars according to the requirement by changing `region` and `AllowedIPs` variables as follows

```
region = "ap-south-1"
AllowedIPs = ["0.0.0.0/0"]
```
Next, Run the following commands to create and destroy your configuration

```
$ terraform init
$ terraform plan
$ terraform apply
$ terraform destroy

```

#### Optional Input Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| prefix | Prefix for resources created by this module | `string` | tf-aws-bigip |
| cidr | aws VPC CIDR | `string` | 10.2.0.0/16 |
| availabilityZones | If you want the VM placed in an Availability Zone, and the AWS region you are deploying to supports it, specify the numbers of the existing Availability Zone you want to use | `List` | ["us-east-1a"] |
| instance_count | Number of Bigip instances to create | `number` | 1 |

#### Output Variables

| Name | Description |
|------|-------------|
| mgmtPublicIP | The actual ip address allocated for the resource |
| mgmtPublicDNS | fqdn to connect to the first vm provisioned |
| mgmtPort | Mgmt Port |
| f5\_username | BIG-IP username |
| bigip\_password | BIG-IP Password (if dynamic_password is choosen it will be random generated password or if aws_secretmanager_auth is choosen it will be aws_secretsmanager_secret_version secret string ) |
| mgmtPublicURL | Complete url including DNS and port|
| private\_addresses | List of BIG-IP private addresses |
| public\_addresses | List of BIG-IP public addresses |
| vpc\_id | VPC Id where BIG-IP Deployed |



```
NOTE: A local json file will get generated which contains the DO declaration
```