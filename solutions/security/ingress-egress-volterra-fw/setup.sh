#!/bin/bash
terraform init
terraform plan
# apply
read -p "Press enter to continue"
terraform apply --auto-approve
