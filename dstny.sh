#!/bin/bash

# source the configuration file to get the details for the cluster and services to be installed
source config.sh

# install the prerequisites for the jump Server
source ./scripts/jump_server_prerequisites.sh

# install the prerequisites for the cluster Nodes
source ./scripts/node_prerequisites.sh

# generate Cluster.yml file for rke
source ./scripts/generate_cluster_configuration_file.sh

# Deploy the Kubernetes cluster using rke
print_label "Deploying the Kubernetes cluster using rke" 1
rke up --config $CLUSTER_FILES_LOCATION/cluster.yml
print_label "Done deploying the Kubernetes cluster using rke" 2

# change the permissions of the kube_config_cluster.yml file
chmod +r $CLUSTER_FILES_LOCATION/kube_config_cluster.yml

# export the KUBECONFIG environment variable
export KUBECONFIG=$CLUSTER_FILES_LOCATION/kube_config_cluster.yml

##############   export KUBECONFIG=${PWD}/cluster_configurations/kube_config_cluster.yml



# if the user wants to install the certification manager.
if [ "$CERT_MANAGER" = "cert-manager" ]; then
  # install and configure cert-manager
  print_label "Installing and configuring cert-manager" 1
  source ./scripts/install_configure_cert_manager.sh
fi

# if the user wants to install the storage system.
if [ "$STORAGE_SYSTEM" = "longhorn" ]; then
  # install and configure longhorn
  print_label "Installing and configuring longhorn" 1
  source ./scripts/install_configure_longhorn.sh
fi

# if the user wants to install the load balancer.
if [ "$LOAD_BALANCER" = "metallb" ]; then
  # install and configure metallb
  print_label "Installing and configuring metallb" 1
  source ./scripts/install_configure_metalLB.sh
fi

# if the user wants to install the monitoring system.
if [ "$MONITORING_SYSTEM" = "prometheus" ]; then
  # install and configure prometheus and grafana
  print_label "Installing and configuring prometheus and grafana" 1
  source ./scripts/install_configure_promethus_and_grafana.sh
fi

# if the user wants to install rancher dashboard.
if [ "$RANCHER_DASHBOARD" = "yes" ]; then
  # install and configure rancher dashboard
  print_label "Installing and configuring rancher dashboard" 1
  source ./scripts/install_configure_rancher_dashboard.sh
fi

# if the user wants to install the logging system.
if [ "$INSTALL_REDIS" = "yes" ]; then
  # install and configure redis
  print_label "Installing and configuring redis" 1
  source scripts/install_configure_redis.sh
fi
