#!/bin/bash
echo "---installing vesctl---"
VERSION=${1:-"0.2.15"}
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

wget https://vesio.azureedge.net/releases/vesctl/"$VERSION"/vesctl.linux-amd64.gz
gzip -d vesctl.linux-amd64.gz
mv vesctl.linux-amd64 /usr/local/bin/vesctl
chmod +x /usr/local/bin/vesctl

echo "---vesctl done---"
