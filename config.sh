#!/bin/bash



# --------------------- main machine info Section ------------------

sudo_password="waer1234"

ANSIBLE_INVENTORY_FILE="${PWD}/playbooks/inventory.yml"



# --------------------- RKE Section ------------------

# Specify the path for the generated cluster.yml file
CLUSTER_FILES_LOCATION="${PWD}/cluster_configurations"

CLUSTER_NAME="Dstny"

# Specify the desired Kubernetes version
KUBERNETES_VERSION="v1.26.7-rancher1-1"

DOCKER_PATH="/var/run/docker.sock"

# LOOK AT IMPORTANT NOTE TO FIND ALL TYPES
NETWORK_PLUGIN="canal"


SSH_KEY_PATH="~/.ssh/id_rsa"
SSH_AGENT_AUTH=false

RKE_VERSION="v1.4.8"

CLUSTER_CIDR="10.42.0.0/16"
SERVICE_CLUSTER_IP_RANGE="10.43.0.0/16"
CLUSTER_DNS_SERVER="10.43.0.10"


METALLB_IP_RANGES=(
    "10.0.0.100-10.0.0.110"
    "10.0.0.120-10.0.0.140"
)

IP_ADDRESSES_POOL_LOCATION="${PWD}/MetalLB-files/ip_address_pool.yaml"

RKE_ADDONS_INCLUDE=(
    "https://github.com/jetstack/cert-manager/releases/download/v1.12.3/cert-manager.yaml"
)


INGRESS_PROVIDER="nginx"
INGRESS_NETWORK_MODE="none"


ADDONS_DIRECTORY="addons"



# --------------------- LONGHORN Section ------------------

LONGHORN_FILES_LOCATION="${PWD}/longhorn-files"

LONGHORN_STORAGE_CLASS_NAME="longhorn"


# --------------------- METALLB Section ------------------


METALLB_FILES_LOCATION="${PWD}/MetalLB-files/"


# --------------------- promthus and grafana Section ------------------

PROMETHEUS_GRAFANA_FILES_LOCATION="${PWD}/prometheus_grafana_files"

K8s_VERSION=$(echo "$KUBERNETES_VERSION" | grep -o 'v[0-9.]*')

DASHBOARDS_DIRECTORY="${PWD}/prometheus_grafana_files/dashboards"

MONITOR_NAMESPACE="monitoring"

GRFANA_SVC="NodePort"

GRAFANA_ADMIN_PASSWORD="waer1234"

GRAFANA_CONFIG_MAPS_DIRECTORY="${PWD}/prometheus_grafana_files/config_maps"
