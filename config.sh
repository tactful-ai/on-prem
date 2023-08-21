#!/bin/bash
# config.sh


# --------------------- main machine info Section ------------------

sudo_password="waer1"


# --------------------- Nodes info Section ------------------


# Number of nodes
num_nodes=3  # Change this value to the desired number of nodes

# Node information array
declare -a node_info

# Populate the node_info array with node information
# node_info[0]="ip_address|password|user"


# --------------------- RKE Section ------------------

# Specify the path for the generated cluster.yml file
CLUSTER_YML="cluster.yml"

CLUSTER_NAME="Dstny"

# Specify the desired Kubernetes version
KUBERNETES_VERSION="v1.24.16-rancher1-1"


DOCKER_PATH="/var/run/docker.sock"

# LOOK AT IMPORTANT NOTE TO FIND ALL TYPES
NETWORK_PLUGIN="calico"


SSH_KEY_PATH="~/.ssh/id_rsa"


