#!/bin/bash

# Load the information from the separate file
source config.sh

INVENTORY_FILE=$ANSIBLE_INVENTORY_FILE


# Remove the existing YAML file if it exists
if [ -f "$INVENTORY_FILE" ]; then
    rm "$INVENTORY_FILE"
fi

# Create a new YAML file with initial content
echo "" > "$INVENTORY_FILE"


# Start building the YAML content using yq
yq eval '.local_device.hosts.localhost.ansible_connection = "local"' -i "$INVENTORY_FILE"
yq eval ".local_device.hosts.localhost.ansible_become_pass = \"$sudo_password\"" -i "$INVENTORY_FILE"


for ((i=0; i<num_nodes; i++)); do
    node="${node_info[$i]}"
    IFS='|' read -ra info <<< "$node"
    hostname=${info[3]}
    ansible_host="${info[0]}"
    ansible_ssh_user="${info[2]}"

    yq eval ".external_vms.hosts.$hostname.ansible_host = \"$ansible_host\"" -i "$INVENTORY_FILE"
    yq eval ".external_vms.hosts.$hostname.ansible_ssh_private_key_file = \"$SSH_KEY_PATH\"" -i "$INVENTORY_FILE"
    yq eval ".external_vms.hosts.$hostname.ansible_ssh_user = \"$ansible_ssh_user\"" -i "$INVENTORY_FILE"
done
