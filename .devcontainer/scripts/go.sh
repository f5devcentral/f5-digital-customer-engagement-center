#!/bin/bash
echo "---install golang---"
version="1.15.6"
wget https://golang.org/dl/go${version}.linux-amd64.tar.gz
tar -C /usr/local -xzf go${version}.linux-amd64.tar.gz
rm go${version}.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
echo "---golang done---"
