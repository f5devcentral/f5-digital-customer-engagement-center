#!/bin/bash
terraform -chdir=vpcs init
terraform -chdir=vpcs plan -var-file=../admin.auto.tfvars
read -p "Press enter to continue"
terraform -chdir=vpcs apply -var-file=../admin.auto.tfvars --auto-approve
# apply
