#!/bin/bash
echo "destroying demo kic"
read -r -p "Are you sure? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    terraform state rm module.eks.kubernetes_config_map.aws_auth[0]
    terraform destroy --auto-approve
else
    echo "canceling"
fi
