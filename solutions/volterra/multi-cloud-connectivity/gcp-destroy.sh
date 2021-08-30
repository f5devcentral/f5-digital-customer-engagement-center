#!/bin/bash
terraform -chdir=gcp destroy -var-file=../admin.auto.tfvars \
    -var buildSuffix=`terraform output -json | jq -r .buildSuffix.value` \
    -var volterraVirtualSite=`terraform output -json | jq -r .volterraVirtualSite.value`
