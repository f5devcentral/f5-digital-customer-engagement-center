#!/bin/bash
terraform init
terraform fmt
terraform validate
terraform plan
# apply
read -p "Press enter to continue"
terraform apply --auto-approve
# kubeconfig
mkdir -p ~/.kube/
yes | cp ./aks-cluster-config ~/.kube/aks-cluster-config
export KUBECONFIG=$KUBECONFIG:~/.kube/aks-cluster-config
