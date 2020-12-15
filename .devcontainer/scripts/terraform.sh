#!/bin/bash
echo "---installing terraform---"
terraformVersion="0.14.0"
sudo wget https://releases.hashicorp.com/terraform/$terraformVersion/terraform_"$terraformVersion"_linux_amd64.zip
sudo unzip -o ./terraform_"$terraformVersion"_linux_amd64.zip -d /usr/local/bin/
sudo rm ./terraform_"$terraformVersion"_linux_amd64.zip
echo "---terraform done---"
