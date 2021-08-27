#!/bin/bash
terraform -chdir=aws init
terraform -chdir=aws apply -var-file=../admin.auto.tfvars
# apply
