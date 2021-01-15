# nginx controller aws

nginx controller and 2 nginx-plus in aws

## requirements
 - network type min
 - kubernetes no
 - ansible no
 - controller license
  -  [trial license](https://www.nginx.com/free-trial-request-nginx-controller/)
 - controller software
  - eg: controller-installer-3.12.0.tar.gz
 - nginx-plus keys
  - [trial keys](https://www.nginx.com/free-trial-request/)

## authentication

option one:
- Set AWS environment variables
```bash
export AWS_ACCESS_KEY_ID="dfsafsa"
export AWS_SECRET_ACCESS_KEY="fdsafds"
export AWS_SESSION_TOKEN="kgnfdskg"
```

## setup
Add your specific instructions or scripts

```bash
cp admin.auto.tfvars.example admin.auto.tfvars
# MODIFY TO YOUR SETTINGS
. setup.sh
```

## demo script

hands off scripting of your configuration deployment EXPECTS infrastructure to exist

```bash
. demo.sh
```
## demo guide step by step

commands step by step for your scripted solution

## cleanup
```bash
. cleanup.sh
```
