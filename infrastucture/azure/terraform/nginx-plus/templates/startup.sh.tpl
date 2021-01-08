#!/bin/bash
#https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/
# logging
LOG_FILE="/status.log"
if [ ! -e $LOG_FILE ]
then
     touch $LOG_FILE
     exec &>>$LOG_FILE
else
    #if file exists, exit as only want to run once
    exit
fi
exec 1>$LOG_FILE 2>&1
echo "starting"
apt-get update
apt-get install jq -y
# make folders
mkdir /etc/ssl/nginx
cd /etc/ssl/nginx
# get cert/key
# license
# access secret from secretsmanager
# google
#secrets=$(gcloud secrets versions access latest --secret="nginx-secret")
#
# azure
secretsUrl="https://${vaultName}.vault.azure.net/secrets/${secretName}/${secretVersion}?api-version=2016-10-01"
saToken=$(curl -s -H 'Metadata: true' 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://vault.azure.net' | jq -r .access_token )
secrets=$(curl -s -H "Authorization: Bearer "$saToken"" "$secretsUrl" | jq -rc .value)
#
# aws
#code here
#
# install cert key
echo "setting info from Metadata secret"
# cert
cat << EOF > /etc/ssl/nginx/nginx-repo.crt
$(echo $secrets | jq -r .cert)
EOF
# key
cat << EOF > /etc/ssl/nginx/nginx-repo.key
$(echo $secrets | jq -r .key)
EOF
# get signing key
wget https://nginx.org/keys/nginx_signing.key
apt-key add nginx_signing.key

# get packages
apt-get install apt-transport-https lsb-release ca-certificates -y
printf "deb https://plus-pkgs.nginx.com/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-plus.list
wget -q -O /etc/apt/apt.conf.d/90nginx https://cs.nginx.com/static/files/90nginx

# install
apt-get update
apt-get install -y nginx-plus
# get controller token
#echo "Retrieving info from Metadata secret"
#controllerToken=$(gcloud secrets versions access latest --secret="controller-agent")

# connect agent to controller
function register() {
# Check api Ready
# google
#ip="$(gcloud compute instances list --filter name:controller --format json | jq -r .[0].networkInterfaces[0].networkIP)"
#zone=$(curl -s -H Metadata-Flavor:Google http://metadata/computeMetadata/v1/instance/zone | cut -d/ -f4)
# azure
#ip=$()
ip="${controllerAddress}"
zone="myzone"
version="api/v1"
loginUrl="/platform/login"
tokenUrl="/platform/global"
agentUrl="/1.4/install/controller/"
locationsUri="/infrastructure/locations"
payload=$(cat -<<EOF
{
  "credentials": {
        "type": "BASIC",
        "username": "$(echo $secrets | jq -r .cuser)",
        "password": "$(echo $secrets | jq -r .cpass)"
  }
}
EOF
)
zonePayload=$(cat -<<EOF
{
  "metadata": {
    "name": "$zone",
    "displayName": "$zone",
    "description": "$zone",
    "tags": ["gce"]
  },
  "desiredState": {
    "type": "OTHER_LOCATION"
  }
}
EOF
)
count=0
while [ $count -le 10 ]
do
status=$(curl -ksi https://$ip/$version$loginUrl  | grep HTTP | awk '{print $2}')
if [[ $status == "401" ]]; then
    echo "ready $status"
    # wait for controller services
    echo "waiting 60 for controller"
    sleep 60
    curl -sk --header "Content-Type:application/json"  --data "$payload" --url https://$ip/$version$loginUrl --dump-header /cookie.txt
    cookie=$(cat /cookie.txt | grep Set-Cookie: | awk '{print $2}')
    rm /cookie.txt
    #create location
    curl -sk --header "Content-Type:application/json" --header "Cookie: $cookie" --data "$zonePayload" --url https://$ip/$version$locationsUri
    # get token
    token=$(curl -sk --header "Content-Type:application/json" --header "Cookie: $cookie" --url https://$ip/$version$tokenUrl | jq -r .desiredState.agentSettings.apiKey)
    # agent install
    curl -ksS -L https://$ip:8443$agentUrl > install.sh && \
    API_KEY="$token" sh ./install.sh --location-name $zone -y
    break
else
    echo "not ready $status"
    count=$[$count+1]
fi
sleep 60
done
}
register
# start nginx
nginx
echo "done"
exit
