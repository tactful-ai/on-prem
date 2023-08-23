#!/bin/bash

source ./scripts/node_prerequisites.sh


source ./scripts/generate_cluster_configuration_file.sh

# Deploy the Kubernetes cluster using rke
rke up --config ./cluster_configurations/cluster.yml


export KUBECONFIG=./cluster_configurations/kube_config_cluster.yml

kubectl get nodes -o wide

kubectl get pods --all-namespaces
