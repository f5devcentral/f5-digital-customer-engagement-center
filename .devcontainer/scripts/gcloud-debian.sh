#!/bin/bash
echo "---installing gcloud---"
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
apt-get update -y && export DEBIAN_FRONTEND=noninteractive && apt-get install -y google-cloud-sdk
echo "---gcloud done---"
