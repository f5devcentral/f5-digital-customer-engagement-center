#!/bin/bash
# Need to make sure random_id is known before full plan/apply, even if user
# provides a buildSuffix value.
terraform -chdir=aws destroy -var-file=../admin.auto.tfvars \
    -var buildSuffix=`terraform output -json | jq -r .buildSuffix.value` \
    -var volterraVirtualSite=`terraform output -json | jq -r .volterraVirtualSite.value`
