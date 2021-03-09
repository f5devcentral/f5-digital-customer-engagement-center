#!/bin/bash
#bash /tmp/scripts/sphinx-debian.sh ${SPHINX_VERSION}
echo "---installing sphinx---"
VERSION=${1:-"3.3.1"}
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

wget https://github.com/sphinx-doc/sphinx/archive/v"${VERSION}".zip
unzip ./v"${VERSION}".zip
cd sphinx-"${VERSION}"
pip3 install .
cd ..
rm -rf sphinx-"${VERSION}" v"${VERSION}".zip
echo "---sphinx done---"
