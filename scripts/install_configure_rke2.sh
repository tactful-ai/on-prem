#!/bin/bash

# Load the information from the separate file
source config.sh
source ./user_fill.sh

mkdir -p $CLUSTER_FILES_LOCATION

MASTER_CONFIG=$CLUSTER_FILES_LOCATION/Master.yml
CLUSTER_TOKEN_LOCATION=$CLUSTER_FILES_LOCATION/rke2_token
CLUSTER_CONFIG_LOCATION=$CLUSTER_FILES_LOCATION/kube_config_cluster.yml
MASTER_PLAYBOOK=${ANSIBLE_PLAYBOOKS_LOCATION}/install_rke2_master.yml


# Remove the existing YAML file if it exists
if [ -f "$MASTER_CONFIG" ]; then
    rm "$MASTER_CONFIG"
fi

# Get the IP address from the first node_info entry
master_node="${node_info[0]}"
IFS='|' read -ra info <<< "$master_node"
export ip_address="${info[0]}"

echo "" > "$MASTER_CONFIG"

yq e ".write-kubeconfig-mode = \"0644\"" -i $MASTER_CONFIG
yq e '.["tls-san"] += [env(ip_address)]' -i $MASTER_CONFIG
yq e ".[].tasks[1].copy.src = \"${MASTER_CONFIG}\" " -i $MASTER_PLAYBOOK
yq e ".[].tasks[6].fetch.dest = \"${CLUSTER_TOKEN_LOCATION}\" " -i $MASTER_PLAYBOOK
yq e ".[].tasks[7].fetch.dest = \"${CLUSTER_CONFIG_LOCATION}\" " -i $MASTER_PLAYBOOK

# ansible-playbook -i $ANSIBLE_INVENTORY_FILE $MASTER_PLAYBOOK


# yq e ".clusters[0].cluster.server = \"https://${ip_address}:6443\" " -i $CLUSTER_CONFIG_LOCATION


YAML_FILE=$CLUSTER_FILES_LOCATION/worker.yml
WORKERS_PLAYBOOK=${ANSIBLE_PLAYBOOKS_LOCATION}/install_rke2_worker.yml
WORKER_CONFIG=$CLUSTER_FILES_LOCATION/worker.yml


# Remove the existing YAML file if it exists
if [ -f "$YAML_FILE" ]; then
    rm "$YAML_FILE"
fi

# Create a YAML file with server and token fields
cat <<EOL > "$YAML_FILE"
server: https://$ip_address:9345
token: $(cat $CLUSTER_TOKEN_LOCATION)
EOL

# Use yq to validate and format the YAML file (optional)
yq eval '.' -i "$YAML_FILE"

yq e ".[].tasks[1].copy.src = \"${WORKER_CONFIG}\" " -i $WORKERS_PLAYBOOK

ansible-playbook -i $ANSIBLE_INVENTORY_FILE $WORKERS_PLAYBOOK

