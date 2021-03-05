# NGINX KIC AKS AZURE

Environment using NGINX KIC with NAP fronting AKS Kubernetes

## requirements
 - azure min
 - kubernetes aks

## authentication

```bash
az login
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
