#!/bin/bash
terraform init
terraform fmt
terraform validate
# Need to make sure random_id is known before full plan/apply, even if user
# provides a buildSuffix value.
terraform apply -auto-approve -target random_id.build_suffix
terraform plan
# apply
read -p "Press enter to continue"
terraform apply --auto-approve
