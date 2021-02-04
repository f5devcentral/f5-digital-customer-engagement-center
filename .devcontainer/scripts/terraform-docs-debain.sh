#!/bin/bash
echo "---installing terraform docs---"

terraformDocsVersion=${1:-"0.9.1"}
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

curl -sLo /usr/local/bin/terraform-docs https://github.com/segmentio/terraform-docs/releases/download/v${terraformDocsVersion}/terraform-docs-v${terraformDocsVersion}-linux-amd64
chmod 0755 /usr/local/bin/terraform-docs

echo "---terraform docs done---"
