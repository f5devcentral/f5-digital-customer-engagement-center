#!/bin/bash
# install tools for container standup
echo "cwd: $(pwd)"
echo "---getting tools---"
# folder permissions
sudo chown -R $USER:$USER /home/codespace/workspace
# tools
. .devcontainer/scripts/azurecli.sh
. .devcontainer/scripts/terraform.sh
. .devcontainer/scripts/terraformDocs.sh
. .devcontainer/scripts/preCommit.sh
. .devcontainer/scripts/tflint.sh
echo "---tools done---"
exit
