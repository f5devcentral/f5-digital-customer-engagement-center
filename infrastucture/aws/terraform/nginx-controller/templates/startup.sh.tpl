#! /bin/bash

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
echo "starting" >> /status.log

sudo apt-get update -y
#install linux utilities identified in docs at https://docs.nginx.com/nginx-controller/v3/install-nginx-controller/
sudo apt-get install -y curl jq gettext gawk bash grep gzip less openssl sed tar coreutils socat conntrack
# sudo apt-get install getent
#install linux utilities identified during NGINX controller setup
sudo apt-get install -y apt-transport-https ca-certificates software-properties-common

#install another package required by NGINX Controller
sudo apt-get install ebtables

# docker settings
mkdir -p /etc/docker
cat << EOF > /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
# install docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
rm get-docker.sh
# install compose
curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
#Run  services for controller
sleep 10
# access secret from secretsmanager
# aws
sudo apt install awscli -y
secrets=$(aws secretsmanager get-secret-value --secret-id ${secretName} --region ${region} | jq -rc .SecretString)

#
cat << EOF > docker-compose.yml
version: "3.3"
services:
  controller-postgres:
    image: postgres:9.5
    ports:
    - "5432:5432"
    restart: always
    environment:
      POSTGRES_USER: "$(echo $secrets | jq -r .dbuser)"
      POSTGRES_PASSWORD: "$(echo $secrets | jq -r .dbpass)"
      POSTGRES_DB: "naas"
  controller-smtp:
    image: namshi/smtp
    ports:
    - "2587:25"
    restart: always
EOF
docker-compose up -d
echo "docker done" >> /status.log

# install controller aws
aws s3api get-object --bucket ${s3_bucket_name} --key ${object_key} /tmp/${object_key}
echo "controller dowloaded" >> /status.log
tar xzf /tmp/${object_key} -C /
cd /controller-installer
echo "controller extracted" >> /status.log

# install k8s dependencies
KUBE_VERSION=1.15.5
packages=(
  "kubeadm=$KUBE_VERSION-00"
  "kubelet=$KUBE_VERSION-00"
  "kubectl=$KUBE_VERSION-00"
)

apt-get update -qq && apt-get install -qq -y apt-transport-https curl gnupg2 >/dev/null
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list >/dev/null
apt-get update -qq

#sudo apt-get update
echo ""
echo "Fetch the following files:"
apt-get install --reinstall --print-uris -qq "$${packages[@]}" | cut -d"'" -f2

echo ""
echo "Install packages:"
echo "dpkg -i *.deb"
echo "k8s deps done" >> /status.log
# # Credentials
echo "creating user" >> /status.log
# create controller user
adduser --disabled-password --shell /bin/bash --gecos "" controller
usermod -aG sudo,adm,docker controller
#echo 'controller ALL=(ALL:ALL) NOPASSWD: ALL' | EDITOR='tee -a' visudo
echo 'controller ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers
# start install
echo "installing controller" >> /status.log

#aws
cat >> /retry.sh << 'EOF'
local_ipv4="$(curl http://169.254.169.254/latest/meta-data/local-ipv4)"
secrets=$(aws secretsmanager get-secret-value --secret-id ${secretName} --region ${region} | jq -rc .SecretString)
pw="$(echo "$secrets" | jq -r .pass)"
admin="$(echo "$secrets" | jq -r .user)"
dbpass="$(echo "$secrets" | jq -r .dbpass)"
dbuser="$(echo "$secrets" | jq -r .dbuser)"
cd /controller-installer/
./install.sh \
--non-interactive \
--accept-license \
--self-signed-cert \
--db-host "$local_ipv4" \
--db-port 5432 \
--db-user "$dbuser" \
--db-pass "$dbpass" \
--smtp-host "$local_ipv4" \
--smtp-port 2587 \
--smtp-authentication false \
--smtp-use-tls false \
--noreply-address noreply@example.com \
--admin-email "$admin" \
--admin-password "$pw" \
--fqdn "$local_ipv4" \
--admin-firstname Admin \
--admin-lastname Nginx \
--tsdb-volume-type local \
--organization-name F5
EOF

chmod +x /retry.sh
su - controller -c "/retry.sh"
#remove rights
sed -i "s/controller ALL=(ALL:ALL) NOPASSWD: ALL//g" /etc/sudoers
rm /retry.sh
# licence
cat << EOF > /controller_license.txt
$(echo $secrets | jq -r .license)
EOF
## payloads
payloadLicense=$(cat -<<EOF
{
  "content": "$(echo -n "$(cat /controller_license.txt)" | base64 -w 0)"
}
EOF
)
payload=$(cat -<<EOF
{
  "credentials": {
        "type": "BASIC",
        "username": "$(echo $secrets | jq -r .user)",
        "password": "$(echo $secrets | jq -r .pass)"
  }
}
EOF
)
function license() {
    # Check api Ready
    ip="$(curl http://169.254.169.254/latest/meta-data/local-ipv4)"
    version="api/v1"
    loginUrl="/platform/login"
    count=0
    while [ $count -le 10 ]
    do
    status=$(curl -ksi https://$ip/$version$loginUrl  | grep HTTP | awk '{print $2}')
    if [[ $status == "401" ]]; then
        curl -sk --header "Content-Type:application/json"  --data "$payload" --url https://$ip/$version$loginUrl --dump-header /cookie.txt
        cookie=$(cat /cookie.txt | grep Set-Cookie: | awk '{print $2}')
        rm /cookie.txt
        curl -sk --header "Content-Type:application/json" --header "Cookie: $cookie" --data "$payloadLicense" --url https://$ip/$version/platform/license-file
        curl -sk --header "Content-Type:application/json" --header "Cookie: $cookie" --url https://$ip/$version/platform/license
        break
    else
        echo "Status $status"
        count=$[$count+1]
    fi
    sleep 60
    done
}
license
function environments() {
environmentsUri="/services/environments"
environments="development test production"
for env in $environments;
do
envPayload=$(cat -<<EOF
{
  "metadata": {
    "name": "$env",
    "displayName": "$env",
    "description": "",
    "tags": []
  },
  "desiredState": {
    "type": "OTHER_LOCATION"
  }
}
EOF
)
echo $envPayload | jq .
curl -sk --header "Content-Type:application/json" --header "Cookie: $cookie" --data "$envPayload" --url https://$ip/$version$environmentsUri
done
}
environments
echo "done" >> /status.log
exit
