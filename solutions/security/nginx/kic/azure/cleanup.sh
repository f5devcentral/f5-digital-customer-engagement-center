#!/bin/bash
echo "destroying demo kic-nap aks"
read -r -p "Are you sure? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    terraform destroy --auto-approve
    rm -f ~/.kube/aks-cluster-config
else
    echo "canceling"
fi
