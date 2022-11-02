#!/bin/bash
terraform -chdir=day2-config-mgmt/azure-functions init
terraform -chdir=day2-config-mgmt/azure-functions apply -var-file=../../admin.auto.tfvars \
    -var buildSuffix=`terraform output -json | jq -r .buildSuffix.value` \
    -var nginxDeploymentName=`terraform output -json | jq -r .nginxDeploymentName.value` \
    -var regionShared=`terraform output -json | jq -r .regionShared.value` \
    -var rgShared=`terraform output -json | jq -r .rgShared.value` \
    -var rgAppWest=`terraform output -json | jq -r .rgAppWest.value` \
    -var rgAppEast=`terraform output -json | jq -r .rgAppEast.value` \
    -var vmssAppWest=`terraform output -json | jq -r .vmssAppWest.value` \
    -var vmssAppEast=`terraform output -json | jq -r .vmssAppEast.value` \
    -var autoscaleSettingsAppWest=`terraform output -json | jq -r .autoscaleSettingsAppWest.value` \
    -var autoscaleSettingsAppEast=`terraform output -json | jq -r .autoscaleSettingsAppEast.value` \
    -auto-approve
