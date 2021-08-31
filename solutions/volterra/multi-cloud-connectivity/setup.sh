#!/bin/bash
terraform init
terraform apply -auto-approve
echo "created random build suffix and virtual site"
