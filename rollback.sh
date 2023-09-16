#!/bin/bash

# source the configuration file to get the details for the cluster and services to be installed
source config.sh
source user_fill.sh

# if the user wants to install the load balancer.
if [ "$LOAD_BALANCER_INSTALLED" = "yes" ]; then
  # install and configure metallb
  print_label "Uninstalling metallb" 1
  source ./rollback_scripts/uninstall_configure_metalLB.sh
fi


# if the user wants to install the monitoring system.
if [ "$MONITORING_SYSTEM_INSTALLED" = "yes" ]; then
  # install and configure prometheus and grafana
  print_label "Uninstalling and configuring prometheus and grafana" 1
  source ./rollback_scripts/uninstall_configure_promethus_and_grafana.sh
fi


# if the user wants to install the certification manager.
if [ "$CERT_MANAGER_INSTALLED" = "yes" ]; then
  # install and configure cert-manager
  print_label "Uninstalling and configuring cert-manager" 1
  source ./rollback_scripts/uninstall_configure_cert_manager.sh
fi


# if the user wants to install the storage system.
if [ "$STORAGE_SYSTEM_INSTALLED" = "yes" ]; then
  # install and configure longhorn
  print_label "Uninstalling and configuring longhorn" 1
  source ./rollback_scripts/uninstall_configure_longhorn.sh
fi


# if the user wants to install rancher dashboard.
if [ "$INSTALL_RANCHER_DASHBOARD" = "yes" ]; then
  # install and configure rancher dashboard
  print_label "Uninstalling and configuring rancher dashboard" 1
  source ./rollback_scripts/uninstall_configure_rancher_dashboard.sh
fi


# if the user wants to install the logging system.
if [ "$INSTALL_REDIS" = "yes" ]; then
  # install and configure redis
  print_label "Uninstalling and configuring redis" 1
  source ./rollback_scripts/uninstall_configure_redis.sh
fi


# if the user wants to install the Adminer.
if [ "$INSTALL_ADMINER" = "yes" ]; then
  # install and configure Adminer
  print_label "Uninstalling and configuring Adminer" 1
  source ./rollback_scripts/uninstall_configure_adminer.sh
fi

