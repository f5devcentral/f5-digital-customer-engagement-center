# gcp nginx-plus


## auth
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

## cleanup
```bash
. cleanup.sh
```
