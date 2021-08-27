#!/bin/bash
terraform -chdir=azure init
terraform -chdir=azure apply -var-file=../admin.auto.tfvars
