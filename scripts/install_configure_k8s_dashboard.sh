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
K8S_TOKEN=$(kubectl get secret admin-user -n kubernetes-dashboard -o jsonpath={".data.token"} | base64 -d)

service_link=$(get_service_info kubernetes-dashboard)

add_service_to_readme "K8s Dashboard Link" "http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/." $K8S_TOKEN

print_label "Kubernetes Dashboard installed, and admin token stored in ./token/admin-token.txt" 2

kubectl proxy &
