# NGINX KIC AKS AZURE

Environment using NGINX KIC with NAP fronting AKS Kubernetes

## requirements
 - azure min
 - kubernetes aks

## authentication

```bash
az login
# or
az login --use-device-code
# you may need to select a subscription
az account set --subscription mySubscriptionName
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
https://github.com/nginxinc/kubernetes-ingress/tree/master/examples-of-custom-resources/waf

## cleanup
```bash
. cleanup.sh
```
