#!/bin/bash

# source the configuration file to get the details for the cluster and services to be installed
source config.sh
source user_fill.sh

# install the prerequisites for the jump Server
source ./scripts/jump_server_prerequisites.sh

# install the prerequisites for the cluster Nodes
source ./scripts/node_prerequisites.sh

# remove the .gitkeep file from addons folder
rm ${ADDONS_DIRECTORY}/.gitkeep

# install rke version based on the user choiceac
if [ "$RKE_VERSION" = "rke1" ]; then
  # install rke1
  source ./scripts/install_configure_rke1.sh
elif [ "$RKE_VERSION" = "rke2" ]; then
  # install rke2
  source ./scripts/install_configure_rke2.sh
fi

print_label "done installing rke Now Upgrading all packages before start using the cluster" 2

UPGRADE_ALL_PACKAGES_PLAYBOOK="${ANSIBLE_PLAYBOOKS_LOCATION}/upgrade_all_packages.yml"

ansible-playbook -i $ANSIBLE_INVENTORY_FILE $UPGRADE_ALL_PACKAGES_PLAYBOOK

# init the output file
init_output_file


# if the user wants to install the certification manager.
if [ "$CERT_MANAGER" = "cert-manager" ]; then
  # install and configure cert-manager
  print_label "Installing and configuring cert-manager" 1
  source ./scripts/install_configure_cert_manager.sh
  print_label "done installing cert-manager" 2
fi

# if the user wants to install the storage system.
if [ "$STORAGE_SYSTEM" = "longhorn" ]; then
  # install and configure longhorn
  print_label "Installing and configuring longhorn" 1
  source ./scripts/install_configure_longhorn.sh
  print_label "done installing longhorn" 2
fi

# if the user wants to install the load balancer.
if [ "$LOAD_BALANCER" = "metallb" ]; then
  # install and configure metallb
  print_label "Installing and configuring metallb" 1
  source ./scripts/install_configure_metalLB.sh
  print_label "done installing metallb" 2
fi

# if the user wants to install the monitoring system.
if [ "$MONITORING_SYSTEM" = "prometheus" ]; then
  # install and configure prometheus and grafana
  print_label "Installing and configuring prometheus and grafana" 1
  source ./scripts/install_configure_promethus_and_grafana.sh
  print_label "done installing prometheus and grafana" 2
fi

# if the user wants to install rancher dashboard.
if [ "$INSTALL_RANCHER_DASHBOARD" = "yes" ]; then
  # install and configure rancher dashboard
  print_label "Installing and configuring rancher dashboard" 1
  source ./scripts/install_configure_rancher_dashboard.sh
  print_label "done installing rancher dashboard" 2
fi

# if the user wants to install the logging system.
if [ "$INSTALL_REDIS" = "yes" ]; then
  # install and configure redis
  print_label "Installing and configuring redis" 1
  source scripts/install_configure_redis.sh
  print_label "done installing redis" 2
fi


# if the user wants to install the Adminer.
if [ "$INSTALL_ADMINER" = "yes" ]; then
  # install and configure Adminer
  print_label "Installing and configuring Adminer" 1
  source scripts/install_configure_adminer.sh
  print_label "done installing Adminer" 2
fi

# if the user wants to install the k8s-dashboard
if [ "$INSTALL_DASHBOARD" = "yes" ]; then
  # install and configure redis
  print_label "Installing and configuring k8s-dashboard and kindly find your token at ./token/admin-token.text" 1
  source scripts/install_configure_k8s_dashboard.sh
  print_label "done installing k8s-dashboard" 2
fi
