#!/bin/bash

# Load the information from the separate files
source config.sh
source ./user_fill.sh

# Delete existing SSH key pair
print_label "Deleting existing SSH key pair" 2
rm -f ~/.ssh/id_rsa*

# Generate SSH key pair without passphrase
print_label "Generating SSH key pair without passphrase" 2
ssh-keygen -t rsa -b 2048 -N "" -f ~/.ssh/id_rsa

# Read the generated public key
public_key=$(cat ~/.ssh/id_rsa.pub)

# Loop through the node_info array
for ((i=0; i<num_nodes; i++)); do
    # Get the node information
    node="${node_info[$i]}"
    # Split the node information into an array
    IFS='|' read -ra info <<< "$node"
    # Get the password, ip address and user
    password="${info[1]}"
    ip_address="${info[0]}"
    user="${info[2]}"

    print_label "Start preparing node $ip_address" 1

    # Run ssh-keyscan and append the key to known_hosts
    print_label "Running ssh-keyscan to get the public key from $ip_address..." 2
    ssh-keyscan "$ip_address" >> ~/.ssh/known_hosts

    # Check the connection way
    if [[ $CONNECTION_WAY -eq 0 ]]; then
        echo "Using password"
        # Copy the public key to the node
        sshpass -p "$password" ssh-copy-id -o PubkeyAuthentication=no "$user@$ip_address"
    else
        echo "using ssh"
        # Copy the public key to the node
        ssh -tt -i "$password" "$user@$ip_address" "echo '$public_key' >> ~/.ssh/authorized_keys"
    fi

    print_label "Preparation completed for node $ip_address" 2
done

# install general prerequisites for all nodes
ansible-playbook -i ./playbooks/inventory.yml ./playbooks/cluster_nodes_prerequisites.yml

# install prerequisites for master nodes
ansible-playbook -i ./playbooks/inventory.yml ./playbooks/master_node_prerequisites.yml

# install prerequisites for worker nodes
ansible-playbook -i ./playbooks/inventory.yml ./playbooks/worker_node_prerequisites.yml
print_label "Done Installing prerequisites for cluster nodes" 2
