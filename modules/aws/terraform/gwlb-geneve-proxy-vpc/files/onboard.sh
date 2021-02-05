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

# repos"
## variables
repositories="${repositories}"
user="ubuntu"
#tool versions
terraformVersion="0.14.5"
terragruntVersion="0.27.3"


set -ex \
&& curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - \
&& sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
&& sudo apt-get update -y \
&& sudo apt-get install -y apt-transport-https wget unzip jq git software-properties-common python3-pip ca-certificates gnupg-agent docker-ce docker-ce-cli containerd.io \
&& echo "docker" \
&& sudo usermod -aG docker ubuntu \
&& sudo chown -R ubuntu: /var/run/docker.sock \
&& echo "terraform" \
&& sudo wget https://releases.hashicorp.com/terraform/"$terraformVersion"/terraform_"$terraformVersion"_linux_amd64.zip \
&& sudo unzip ./terraform_"$terraformVersion"_linux_amd64.zip -d /usr/local/bin/ \
&& echo "awscli" \
&& sudo apt-get install awscli -y \
&& echo "f5 cli" \
&& pip3 install f5-cli \
&& echo "terragrunt" \
&& sudo wget https://github.com/gruntwork-io/terragrunt/releases/download/v"$terragruntVersion"/terragrunt_linux_amd64 \
&& sudo mv ./terragrunt_linux_amd64 /usr/local/bin/terragrunt \
&& sudo chmod +x /usr/local/bin/terragrunt \
&& echo "chef Inspec" \
&& curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P inspec \
&& echo "auto completion" \
&& complete -C '/usr/bin/aws_completer' aws \
&& terraform -install-autocomplete

echo "test tools"
echo '# test tools' >>/home/ubuntu/.bashrc
echo '/bin/bash /testTools.sh' >>/home/ubuntu/.bashrc
cat > /testTools.sh <<EOF
#!/bin/bash
echo "=====Installed Versions====="
terraform -version
echo "inspec:"
inspec version
terragrunt -version
f5 --version
aws --version
echo "=====Installed Versions====="
EOF
echo "clone repositories"
cwd=$(pwd)
ifsDefault=$IFS
IFS=','
cd /home/ubuntu
for repo in $repositories
do
    git clone $repo
    name=$(basename $repo )
    folder=$(basename $name .git)
    sudo chown -R ubuntu $folder
done
IFS=$ifsDefault
cd $cwd
echo "=====done====="
exit
