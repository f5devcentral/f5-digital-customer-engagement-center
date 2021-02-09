#!/bin/bash
echo "---installing terraform---"
VERSION=${1:-"0.14.0"}
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

wget https://releases.hashicorp.com/terraform/$VERSION/terraform_"$VERSION"_linux_amd64.zip
unzip -o ./terraform_"$VERSION"_linux_amd64.zip -d /usr/local/bin/
rm -f ./terraform_"$VERSION"_linux_amd64.zip

echo "---terraform done---"
