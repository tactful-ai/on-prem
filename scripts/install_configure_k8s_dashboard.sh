#!/bin/bash
# Install Kubernetes Dashboard

source ./config.sh
source ./user_fill.sh

print_label "Installing Kubernetes Dashboard" 1
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
kubectl apply -f ./k8s-dashboard-manifests/ServiceAccount.yaml
kubectl apply -f ./k8s-dashboard-manifests/ClusterRoleBinding.yaml
kubectl apply -f ./k8s-dashboard-manifests/Secret.yaml

# Get and store the admin user token in a text file
kubectl get secret admin-user -n kubernetes-dashboard -o jsonpath={".data.token"} | base64 -d > ./token/admin-token.txt

print_label "Kubernetes Dashboard installed, and admin token stored in ./token/admin-token.txt" 2

kubectl proxy &