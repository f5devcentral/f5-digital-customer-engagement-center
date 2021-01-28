#!/bin/bash

# extract the BIG-IP details from the Terraform output
export BIGIP_MGMT_IP=`terraform output --json | jq -cr '.mgmtPublicIP.value[]'[]`
export BIGIP_USER=`terraform output --json | jq -cr '.f5_username.value[]'`
export BIGIP_PASSWORD=`terraform output --json | jq -cr '.bigip_password.value[]'`
export BIGIP_MGMT_PORT=`terraform output --json | jq -cr '.mgmtPort.value[]'`

export DO_VERSION=1.13.0
export AS3_VERSION=3.20.0
export TS_VERSION=1.12.0
export FAST_VERSION=1.3.0
export CFE_VERSION=1.5.0

#Run InSpect tests from the Jumphost
inspec exec ../inspec/bigip-ready  --input bigip_address=$BIGIP_MGMT_IP bigip_port=$BIGIP_MGMT_PORT user=$BIGIP_USER password=$BIGIP_PASSWORD do_version=$DO_VERSION as3_version=$AS3_VERSION ts_version=$TS_VERSION fast_version=$FAST_VERSION cfe_version=$CFE_VERSION
