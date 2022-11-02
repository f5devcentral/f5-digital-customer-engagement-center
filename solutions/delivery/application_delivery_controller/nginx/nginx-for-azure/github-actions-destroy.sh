#!/bin/bash
terraform -chdir=day2-config-mgmt/github-actions destroy -var-file=../../admin.auto.tfvars \
    -var buildSuffix=`terraform output -json | jq -r .buildSuffix.value` \
    -var nginxDeploymentName=`terraform output -json | jq -r .nginxDeploymentName.value` \
    -var rgShared=`terraform output -json | jq -r .rgShared.value` \
    -var rgAppWest=`terraform output -json | jq -r .rgAppWest.value` \
    -var rgAppEast=`terraform output -json | jq -r .rgAppEast.value` \
    -var vmssAppWest=`terraform output -json | jq -r .vmssAppWest.value` \
    -var vmssAppEast=`terraform output -json | jq -r .vmssAppEast.value`
