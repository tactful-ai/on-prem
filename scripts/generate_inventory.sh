#!/bin/bash

# Load the information from the separate file
source config.sh
source ./user_fill.sh

INVENTORY_FILE=$ANSIBLE_INVENTORY_FILE

# Remove the existing YAML file if it exists
if [ -f "$INVENTORY_FILE" ]; then
    rm "$INVENTORY_FILE"
fi

# Create a new YAML file with initial content
echo "" > "$INVENTORY_FILE"

# define the local host as the first vm in the inventory
yq eval '.local_device.hosts.localhost.ansible_connection = "local"' -i "$INVENTORY_FILE"
yq eval ".local_device.hosts.localhost.ansible_become_pass = \"$sudo_password\"" -i "$INVENTORY_FILE"


# define the master node in the inventory
node="${node_info[0]}"
IFS='|' read -ra info <<< "$node"
hostname=master1
ansible_host="${info[0]}"
ansible_ssh_user="${info[2]}"
root_password="${info[1]}"
echo "Adding $hostname to the inventory file"

yq eval ".master_nodes.hosts.$hostname.ansible_host = \"$ansible_host\"" -i "$INVENTORY_FILE"
yq eval ".master_nodes.hosts.$hostname.ansible_ssh_private_key_file = \"$SSH_KEY_PATH\"" -i "$INVENTORY_FILE"
yq eval ".master_nodes.hosts.$hostname.ansible_ssh_user = \"$ansible_ssh_user\"" -i "$INVENTORY_FILE"


for ((i=1; i<num_nodes; i++)); do
    node="${node_info[$i]}"
    IFS='|' read -ra info <<< "$node"
    hostname=worker-node-${i}
    ansible_host="${info[0]}"
    ansible_ssh_user="${info[2]}"
    root_password="${info[1]}"
    echo "Adding $hostname to the inventory file"

    yq eval ".worker_nodes.hosts.$hostname.ansible_host = \"$ansible_host\"" -i "$INVENTORY_FILE"
    yq eval ".worker_nodes.hosts.$hostname.ansible_ssh_private_key_file = \"$SSH_KEY_PATH\"" -i "$INVENTORY_FILE"
    yq eval ".worker_nodes.hosts.$hostname.ansible_ssh_user = \"$ansible_ssh_user\"" -i "$INVENTORY_FILE"
done
