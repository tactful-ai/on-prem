#!/bin/bash



# --------------------- main machine info Section ------------------

sudo_password="waer1"

ANSIBLE_INVENTORY_FILE="./playbooks/inventory.yml"



# --------------------- RKE Section ------------------

# Specify the path for the generated cluster.yml file
CLUSTER_YML="./cluster_configurations/cluster.yml"

CLUSTER_NAME="Dstny"

# Specify the desired Kubernetes version
KUBERNETES_VERSION="v1.26.7-rancher1-1"

DOCKER_PATH="/var/run/docker.sock"

# LOOK AT IMPORTANT NOTE TO FIND ALL TYPES
NETWORK_PLUGIN="flannel"


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

IP_ADDRESSES_POOL_LOCATION="./MetalLB-files/ip_address_pool.yaml"

RKE_ADDONS_INCLUDE=(
    "https://github.com/jetstack/cert-manager/releases/download/v1.12.3/cert-manager.yaml"
)


INGRESS_PROVIDER="nginx"
INGRESS_NETWORK_MODE="none"


ADDONS_DIRECTORY="addons"

