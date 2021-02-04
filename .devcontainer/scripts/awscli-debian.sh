#!/bin/bash
echo "---installing awscli---"
export DEBIAN_FRONTEND=noninteractive
apt-get install -y --no-install-recommends python3-setuptools
python3 -m pip install --upgrade pip
pip3 install awscli
echo "---installing awscli done---"
