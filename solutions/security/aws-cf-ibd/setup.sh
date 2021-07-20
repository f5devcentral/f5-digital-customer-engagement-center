#!/bin/bash
terraform -chdir=webapp init
terraform init
read -p "Press enter to continue"
terraform -chdir=webapp apply -var-file=../admin.auto.tfvars --auto-approve
terraform apply --auto-approve
# apply
