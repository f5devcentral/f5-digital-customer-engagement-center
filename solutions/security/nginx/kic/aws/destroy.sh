#!/bin/bash
module=$1

echo "deleteing all resources in module ${module}"

read -r -p "Are you sure? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    list=$(terraform state list | grep module.${module})
    for item in $list
    do
	terraform destroy --target $item --auto-approve
    done
else
    echo "canceling"
fi
