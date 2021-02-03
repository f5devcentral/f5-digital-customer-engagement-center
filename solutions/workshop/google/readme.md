# Google workshop

Example workshop for students to connect and run labs with coder as the web interface

instructor can deploy the lab then hand out ips/credentials to students.

## requirements
 - network google min
 - kubernetes no
 - jumphost gcp

## authentication

```bash
PROJECT_ID="myprojectid"
gcloud auth login
gcloud config set project $PROJECT_ID
gcloud auth application-default login
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
| google | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| adminAccountName | admin account | `any` | n/a | yes |
| adminPassword | admin password | `any` | n/a | yes |
| adminSourceAddress | admin src address in cidr | `list` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| gcpProjectId | gcp project id | `any` | n/a | yes |
| gcpRegion | region where gke is deployed | `string` | `"us-east1"` | no |
| gcpZone | zone where gke is deployed | `string` | `"us-east1-b"` | no |
| projectPrefix | prefix for resources | `string` | `"workshop"` | no |
| sshPublicKey | contents of admin ssh public key | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| coderAccountPassword | n/a |
| student1 | n/a |
| student2 | n/a |
| student3 | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
