#!/bin/bash
terraform -chdir=gcp destroy -var-file=../admin.auto.tfvars
# apply
