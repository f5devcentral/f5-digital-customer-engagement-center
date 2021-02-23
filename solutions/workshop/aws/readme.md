# aws workshop

Example workshop for students to connect and run labs with coder as the web interface

instructor can deploy the lab then hand out ips/credentials to students.

## requirements
 - network aws min
 - kubernetes no
 - jumphost aws

## authentication

option one:
- Set AWS environment variables
```bash
export AWS_ACCESS_KEY_ID="dfsafsa"
export AWS_SECRET_ACCESS_KEY="fdsafds"
export AWS_SESSION_TOKEN="kgnfdskg"
```

## setup
Add your specific instructions or scripts

```bash
cp admin.auto.tfvars.example admin.auto.tfvars
# MODIFY TO YOUR SETTINGS
. setup.sh
```

## demo script

hands off scripting of your configuration deployment EXPECTS infrastructure to exist

```bash
. demo.sh
```
## demo guide step by step

commands step by step for your scripted solution

## cleanup
```bash
. cleanup.sh
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |
| tls | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| adminAccountName | admin | `string` | `"xadmin"` | no |
| adminSourceCidr | n/a | `string` | `"0.0.0.0/0"` | no |
| awsAz1 | n/a | `any` | `null` | no |
| awsAz2 | n/a | `any` | `null` | no |
| awsRegion | n/a | `string` | `"us-east-2"` | no |
| clusterName | eks cluster name | `string` | `"my-cluster"` | no |
| kubernetes | deploy a kubernetes cluster or not | `bool` | `true` | no |
| projectPrefix | cloud | `string` | `"kic-aws"` | no |
| resourceOwner | tag used to mark instance owner | `string` | `"dcec-kic-user"` | no |
| sshPublicKey | ssh key file to create an ec2 key-pair | `string` | `"ssh-rsa AAAAB3...."` | no |
| students | Map of student names | `map(any)` | <pre>{<br>  "student1": {<br>    "projectPrefix": "workshop-student-1",<br>    "resourceOwner": "student1"<br>  },<br>  "student2": {<br>    "projectPrefix": "workshop-student-2",<br>    "resourceOwner": "student2"<br>  }<br>}</pre> | no |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
