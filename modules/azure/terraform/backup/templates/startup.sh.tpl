#!/bin/bash
# logging
LOG_FILE=/var/log/startup-script.log
if [ ! -e $LOG_FILE ]
then
     touch $LOG_FILE
     exec &>>$LOG_FILE
else
    #if file exists, exit as only want to run once
    exit
fi

exec 1>$LOG_FILE 2>&1

## variables
user="ubuntu"
#
set -ex \
&&  apt-get update -y \
&&  apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common \
&& echo "docker" \
&&  curl -fsSL https://get.docker.com -o get-docker.sh \
&&  sh get-docker.sh \
&&  while ! docker --version; do echo trying again&sleep 1; done \
&& echo "start app" \
&&  ${startupCommand}

echo "=====done====="
exit
