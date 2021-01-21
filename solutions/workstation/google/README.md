# gcp workstation

ubuntu 20.04 instance with coder and tools for working in terraform

## requirements
 - network type gcp min

## authentication
```bash
PROJECT_ID="myprojectid"
gcloud auth login
gcloud config set project $PROJECT_ID
gcloud auth application-default login
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
