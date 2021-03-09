# automation related to your script
# pull containers for ansible etc.
# should configure whole solution
echo "==== starting kic nap ===="
export KUBECONFIG=$KUBECONFIG:~/.kube/aks-cluster-config
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

# get secrets
echo "get secrets"
secrets=$(az keyvault secret show --id $SECRET_ID | jq -rc .value)
# cert
cat << EOF > kubernetes-ingress/nginx-repo.crt
$(echo $secrets | jq -r .cert)
EOF
# key
cat << EOF > kubernetes-ingress/nginx-repo.key
$(echo $secrets | jq -r .key)
EOF
# build kic
cd kubernetes-ingress/
make DOCKERFILE=DockerfileForPlus VERSION=v1.10.0 PREFIX=${ACR}/nginx-plus-ingress
#make DOCKERFILE=appprotect/DockerfileWithAppProtectForPlus VERSION=v1.10.0 PREFIX=${ACR}/nginx-plus-ingress
cd ..
# modify for custom registry
# backup
cp ../templates/kic/nginx-ingress-install.yml.source ../templates/kic/nginx-ingress-install.yml
sed -i "s/-image-/${ACR}\/nginx-plus-ingress:v1.10.0/g" ../templates/kic/nginx-ingress-install.yml
# deploy kic and dashboard
kubectl apply -f ../templates/kic/nginx-ingress-install.yml
# add dashboard
kubectl apply -f ../templates/kic/nginx-ingress-dashboard.yml
# deploy app
kubectl apply -f ../templates/arcadia/arcadia.yml
# deploy ingress
echo "==== waiting for ingress to settle ===="
sleep 30
# check services
kubectl get all -n nginx-ingress
# get ingress ip
ingress=$(kubectl get service -n nginx-ingress nginx-ingress -o json | jq -r .status.loadBalancer.ingress[0].ip)
# modify ingress
#backup
cp ../templates/arcadia/ingress-arcadia-demo.yml.source ../templates/arcadia/ingress-arcadia-demo.yml
sed -i "s/-host-/${ingress}/g" ../templates/arcadia/ingress-arcadia-demo.yml
kubectl apply -f ../templates/arcadia
echo "==== done ===="
