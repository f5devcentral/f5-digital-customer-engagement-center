#!/bin/bash
# Need to make sure random_id is known before full plan/apply, even if user
# provides a buildSuffix value.
terraform -chdir=aws destroy -var-file=../admin.auto.tfvars
