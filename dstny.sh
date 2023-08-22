#!/bin/bash

# Load the information from the separate file
source config.sh


source ./scripts/node_prerequisites.sh


source ./scripts/generate_cluster_configuration_file.sh

# Deploy the Kubernetes cluster using rke
rke up --config cluster.yml


# export KUBECONFIG=./kube_config_cluster.yml

