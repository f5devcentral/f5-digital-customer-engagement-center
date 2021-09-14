#!/bin/bash
terraform init
terraform fmt
terraform validate
# apply
read -p "Press enter to continue"
terraform apply --auto-approve
