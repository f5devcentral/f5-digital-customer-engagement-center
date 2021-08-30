#!/bin/bash
export VOLT_API_TIMEOUT=180s
terraform init
terraform apply -auto-approve
echo "created random build suffix and virtual site"
