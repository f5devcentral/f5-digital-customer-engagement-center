#!/bin/bash
terraform init
terraform plan
read -p "Press enter to continue"
terraform apply --auto-approve
# apply
