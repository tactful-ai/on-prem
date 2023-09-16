#!/bin/bash

# source the configuration file to get the details for the cluster and services to be installed
source config.sh
source user_fill.sh


# install the prerequisites for the jump Server
source ./scripts/jump_server_prerequisites.sh

# install the prerequisites for the cluster Nodes
source ./scripts/node_prerequisites.sh

# Set up error handling to execute rollback.sh on error
trap './rollback.sh' ERR

# install rke version based on the user choice
if [ "$RKE_VERSION" = "rke1" ]; then
  # install rke1
  source ./scripts/install_configure_rke1.sh
elif [ "$RKE_VERSION" = "rke2" ]; then
  # install rke2
  source ./scripts/install_configure_rke2.sh
fi

##############   export KUBECONFIG=${PWD}/cluster_configurations/kube_config_cluster.yml


print_label "done installing rke Now Wait 60 second for start using it" 2

sleep 60

# check cluster health
kubectl cluster-info


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
if [ "$INSTALL_RANCHER_DASHBOARD" = "yes" ]; then
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


# if the user wants to install the Adminer.
if [ "$INSTALL_ADMINER" = "yes" ]; then
  # install and configure Adminer
  print_label "Installing and configuring Adminer" 1
  source scripts/install_configure_adminer.sh
fi


# if the user wants to install the k8s-dashboard
if [ "$INSTALL_DASHBOARD" = "yes" ]; then
  # install and configure redis
  print_label "Installing and configuring k8s-dashboard and kindly find your token at ./token/admin-token.text" 1
  source scripts/install_configure_k8s_dashboard.sh
fi


exit 0