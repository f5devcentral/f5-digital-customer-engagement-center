#!/bin/bash
echo "---installing awscli---"
sudo apt-get install -y python3-setuptools
python3 -m pip install --upgrade pip
pip3 install awscli
echo "---installing awscli done---"
