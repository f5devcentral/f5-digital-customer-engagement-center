#!/bin/bash
echo "---installing terraformDocs---"
# terraform docs
terraformDocsVersion="0.9.1"
sudo curl -sLo /usr/local/bin/terraform-docs https://github.com/segmentio/terraform-docs/releases/download/v${terraformDocsVersion}/terraform-docs-v${terraformDocsVersion}-linux-amd64
sudo chmod 0755 /usr/local/bin/terraform-docs
echo "---terraformDocs done---"
