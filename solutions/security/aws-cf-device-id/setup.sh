#!/bin/bash
terraform -chdir=webapp init
terraform init
terraform -chdir=webapp plan -var-file=../admin.auto.tfvars
terraform plan
read -p "Press enter to continue"
terraform -chdir=webapp apply --auto-approve
terraform apply --auto-approve
# apply
