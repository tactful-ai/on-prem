#!/bin/bash

# Load the information from the separate file
source config.sh
source ./user_fill.sh

ansible-playbook -i ./playbooks/inventory.yml ./playbooks/install_rke2_master.yml

YAML_FILE=$CLUSTER_FILES_LOCATION/cluster.yml

# Remove the existing YAML file if it exists
if [ -f "$YAML_FILE" ]; then
    rm "$YAML_FILE"
fi

mkdir -p $CLUSTER_FILES_LOCATION

# Get the IP address from the first node_info entry
master_node="${node_info[0]}"
IFS='|' read -ra info <<< "$master_node"
ip_address="${info[0]}"

# Create a YAML file with server and token fields
cat <<EOL > "$YAML_FILE"
server: https://$ip_address:9345
token: $(cat /tmp/rke2_token)
EOL

# Use yq to validate and format the YAML file (optional)
yq eval '.' -i "$YAML_FILE"

ansible-playbook -i ./playbooks/inventory.yml ./playbooks/install_rke2_worker.yml
