# automation related to your script
# pull containers for ansible etc.
# should configure whole solution
RG=$(terraform output -raw resource_group_name)
AKS=$(terraform output -raw aks_name)
ACR_NAME=$(terraform output -raw acr_name)
ACR=$(terraform output -raw acr_login_url)
# secrets
SECRET_ID=$(terraform output -raw secret_id)
TOKEN=$(az acr login -n $ACR --expose-token | jq -r .accessToken)

# associate ACR with AKS
az aks update -n $AKS -g $RG --attach-acr $ACR_NAME

# connect docker to ACR
docker login $ACR -u 00000000-0000-0000-0000-000000000000 -p $TOKEN

# build clone ingress repo
git clone -b 'v1.10.0' --single-branch https://github.com/nginxinc/kubernetes-ingress
cd kubernetes-ingress/

# get secrets
echo "get secrets"
secrets=$(az keyvault secret show --id $SECRET_ID | jq -rc .value)
# cert
cat << EOF > nginx-repo.crt
$(echo $secrets | jq -r .cert)
EOF
# key
cat << EOF > nginx-repo.key
$(echo $secrets | jq -r .key)
EOF
# build plus
make DOCKERFILE=appprotect/DockerfileWithAppProtectForPlus VERSION=v1.10.0 PREFIX=${ACR}/nginx-plus-ingress
cd ..
# deploy plus
# cp kic/nginx-plus-ingress-src.yaml kic/nginx-plus-ingress.yaml
# sed -i "s/nginx-plus-ingress:1.9.1/gcr.io\/${GCP_PROJECT}\/nginx-plus-ingress:v1.9.1/g" kic/nginx-plus-ingress.yaml
echo "==done=="
