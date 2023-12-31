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

# copy the kube_config_cluster.yml file to the ~/.kube/config file
mkdir ~/.kube
cp $CLUSTER_FILES_LOCATION/kube_config_cluster.yml ~/.kube/config
chmod 600 /root/.kube/config

############################## Upgrading all packages ######################

print_label "done installing rke Now Upgrading all packages before start using the cluster" 2

UPGRADE_ALL_PACKAGES_PLAYBOOK="${ANSIBLE_PLAYBOOKS_LOCATION}/upgrade_all_packages.yml"
ansible-playbook -i $ANSIBLE_INVENTORY_FILE $UPGRADE_ALL_PACKAGES_PLAYBOOK

