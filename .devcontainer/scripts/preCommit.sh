#!/bin/bash
echo "---installing pre-commit---"
# pre commit
sudo apt update
sudo apt install python3.8 python3-pip -y
sudo pip3 install pre-commit
pre-commit install
echo "---pre-commit done---"
