#!/bin/bash

# source the configuration file to get the details for the cluster and services to be installed
source config.sh
source user_fill.sh

# generate Cluster.yml file for rke
source ./scripts/generate_cluster_configuration_file.sh

# Deploy the Kubernetes cluster using rke
print_label "Deploying the Kubernetes cluster using rke" 1
rke up --config $CLUSTER_FILES_LOCATION/cluster.yml
print_label "Done deploying the Kubernetes cluster using rke1" 2

# change the permissions of the kube_config_cluster.yml file
chmod +r $CLUSTER_FILES_LOCATION/kube_config_cluster.yml

# export the KUBECONFIG environment variable
# export KUBECONFIG=$CLUSTER_FILES_LOCATION/kube_config_cluster.yml

mkdir ~/.kube
cp $CLUSTER_FILES_LOCATION/kube_config_cluster.yml ~/.kube/config
