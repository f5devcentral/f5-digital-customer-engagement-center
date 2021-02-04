#!/bin/bash
echo "---create user---"
USERNAME=${1:-codespace}
USER_UID=${2:-1000}

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi
# create user
adduser --disabled-password --gecos "" --uid ${USER_UID} ${USERNAME}
# add to sudoers
cat > /etc/sudoers.d/${USERNAME}-user <<EOF
${USERNAME} ALL=(ALL) NOPASSWD:ALL
EOF

echo "---create user done---"
