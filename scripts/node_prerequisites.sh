#!/bin/bash

# Load the information from the separate file
source config.sh
source ./secrets/vms_info.sh


if [[ "$HAVE_DEFAULT_PASSWORD" == "true" ]]; then
    bash ./scripts/change_default_password.sh
fi

# Delete existing SSH key pair
echo "Deleting existing SSH key pair"
rm -f ~/.ssh/id_rsa*

# Generate SSH key pair without passphrase
echo "Generating SSH key pair without passphrase"
ssh-keygen -t rsa -b 2048 -N "" -f ~/.ssh/id_rsa

# Read the generated public key
public_key=$(cat ~/.ssh/id_rsa.pub)

# Loop through the node_info array
for ((i=0; i<num_nodes; i++)); do
    node="${node_info[$i]}"
    IFS='|' read -ra info <<< "$node"

    ip_address="${info[0]}"
    user="${info[2]}"

    if [[ "$HAVE_DEFAULT_PASSWORD" == "true" ]]; then
        password="${NEW_MACHINES_PASSWORD}"
    else
        password="${info[1]}"
    fi


    echo "Start preparing node $ip_address"

    # Run ssh-keyscan and append the key to known_hosts
    echo "Running ssh-keyscan to get the public key from $ip_address..."
    ssh-keyscan "$ip_address" >> ~/.ssh/known_hosts


    if [[ $CONNECTION_WAY -eq 0 ]]; then
        echo "Using password"
        sshpass -p "$password" ssh-copy-id -o PubkeyAuthentication=no "$user@$ip_address"
    else
        echo "using ssh"
        ssh -tt -i "$password" "$user@$ip_address" "echo '$public_key' >> ~/.ssh/authorized_keys"
    fi


    echo "Preparation completed for node $ip_address"
done

if ! command -v yq &>/dev/null; then
    wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v4.34.2/yq_linux_amd64
    chmod +x /usr/local/bin/yq
else
    echo "YQ is already installed."
fi

source ./scripts/generate_inventory.sh

ansible-playbook -i ./playbooks/inventory.yml ./playbooks/jump_server_prerequisites.yml

ansible-playbook -i ./playbooks/inventory.yml ./playbooks/cluster_nodes_prerequisites.yml




