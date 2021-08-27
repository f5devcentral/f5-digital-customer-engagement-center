#!/bin/bash
export VOLT_API_TIMEOUT=180s
terraform init
terraform apply -auto-approve
export TF_VAR_buildSuffix=`terraform output -json | jq -r .buildSuffix.value`
export TF_VAR_volterraVirtualSite=`terraform output -json | jq -r .volterraVirtualSite.value`
echo "created random build suffix and virtual site"