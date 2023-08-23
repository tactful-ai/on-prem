#!/bin/bash
# config.sh

# we need to open ports 10250, 2379 on all nodes and disable firewall for them



# --------------------- main machine info Section ------------------

sudo_password="waer1"

ANSIBLE_INVENTORY_FILE="./playbooks/inventory.yml"


# --------------------- Nodes info Section ------------------

# it can be PASSWORD=0 or SSH_KEY=1
CONNECTION_WAY=0

# Number of nodes
num_nodes=3

# Node information array
declare -a node_info

# Populate the node_info array with node information
# node_info[0]="ip_address|password|user|node_name" in case of using password
# node_info[0]="ip_address|ssh_key_path|user|node_name" in case of using ssh key



# --------------------- RKE Section ------------------

# Specify the path for the generated cluster.yml file
CLUSTER_YML="./cluster_configurations/cluster.yml"

CLUSTER_NAME="Dstny"

# Specify the desired Kubernetes version
KUBERNETES_VERSION="v1.24.16-rancher1-1"


DOCKER_PATH="/var/run/docker.sock"

# LOOK AT IMPORTANT NOTE TO FIND ALL TYPES
NETWORK_PLUGIN="calico"


SSH_KEY_PATH="~/.ssh/id_rsa"
SSH_AGENT_AUTH=false

RKE_VERSION="v1.4.8"
