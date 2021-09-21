#!/bin/bash
terraform init -upgrade
terraform fmt
terraform validate
# apply
read -p "Press enter to continue"
terraform apply --auto-approve
