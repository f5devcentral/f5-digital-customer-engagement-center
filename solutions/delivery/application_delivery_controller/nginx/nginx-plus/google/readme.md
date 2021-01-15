# gcp nginx-plus
  - network type gcp min
  - ansible false
  - ubuntu virtual machine nginx-plus

## login
```bash
PROJECT_ID="myprojectid"
gcloud auth login
gcloud config set project $PROJECT_ID
gcloud auth application-default login
```

## setup
```bash
cp admin.auto.tfvars.example admin.auto.tfvars
# MODIFY TO YOUR SETTINGS
. setup.sh
```
## run lab steps
```
< lab steps here>
```
## cleanup
```bash
. cleanup.sh
```
