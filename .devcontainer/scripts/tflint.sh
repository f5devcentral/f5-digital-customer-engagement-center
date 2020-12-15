#!/bin/bash/
echo "---installing tflint---"
if [ -z "$USER" ]
then
    USER="codespace"
fi
# requires make
curl -sL https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
# azure plugin
wget https://github.com/terraform-linters/tflint-ruleset-azurerm/releases/download/v0.6.0/tflint-ruleset-azurerm_linux_amd64.zip
mkdir -p /home/$USER/.tflint.d/plugins
unzip ./tflint-ruleset-azurerm_linux_amd64.zip -d /home/$USER/.tflint.d/plugins
rm ./tflint-ruleset-azurerm_linux_amd64.zip*
echo "---tflint done---"
