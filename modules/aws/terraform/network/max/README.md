[![license](https://img.shields.io/github/license/merps/f5-cwl-telegraf)](LICENSE)
[![standard-readme compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)

# F5 Digital Customer Engagement Center (AWS VPC MAX Module)

This module has been explicitly written to support AWS demo environment creation, as such it leverages the upstream [`terraform-aws-moddule`](https://github.com/terraform-aws-modules/terraform-aws-vpc) offered by HashiCorp.  

Deployment of the VPC configuration is based upon BIG-IP MutliNIC configuration as documented [here](https://clouddocs.f5.com/cloud/public/v1/aws/AWS_multiNIC.html).  There is also some other stuff along the way...

## Prerequisites

To support this deployment pattern the following components are required:

* [Terraform CLI](https://www.terraform.io/docs/cli-index.html)
* [git](https://git-scm.com/)
* [AWS CLI](https://aws.amazon.com/cli/) access.
* [AWS Access Credentials](https://docs.aws.amazon.com/general/latest/gr/aws-security-credentials.html)


## Installation 

Insallation of this module/src is performed on 'terraform init', referenced within the calling module as so:

```hcl
# Create VPC as per requirements
module "vpc" {
  source = "../modules/awsInfra/vpc"
  ...<snip>
```

#### Inputs
The following input variblaes are required for this module;

Name | Description | Type | Default | Required
---|---|---|---|---
cidr | CIDR Range for VPC | String | *NA* | **Yes**
region | AWS Deployment Region | String | *NA* | **Yes**
azs | AWS Availability Zones | List | *NA* | **Yes**
prefix | Prefix used for AWS Tag/Naming | String | `prefix` | No


#### Outputs
The following output values are returned by this module;

Name | Description | Type 
---|---|---|
vpc_id | The ID of the VPC | String
vpc_cidr_block | The CIDR block of the VPC | String 
private_subnets | List of IDs of private subnets | list(string)
public_subnets | List of IDs of public subnets | list(string)
database_subnets | List of IDs of database subnets | list(string)
infra_subnets | List of IDs of intra subnets | list(string)
nat_public_ips | List of public Elastic IPs created for AWS NAT Gateway | list(string)

## Usage

**TBC**

## TODO 

**TBC**

## Contributing

See [the contributing file](CONTRIBUTING.md)!

PRs accepted.

## License

[Apache](../LICENSE)
