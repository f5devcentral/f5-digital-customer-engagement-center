#!/bin/bash
terraform -chdir=gcp init
terraform -chdir=gcp apply -var-file=../admin.auto.tfvars
# apply
