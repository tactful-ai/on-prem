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
        # Copy the public key to the node
        sshpass -p "$password" ssh-copy-id -o PubkeyAuthentication=no "$user@$ip_address"
    else
        # Copy the public key to the node
        ssh -tt -i "$password" "$user@$ip_address" "echo '$public_key' >> ~/.ssh/authorized_keys"
    fi

    print_label "Preparation completed for node $ip_address" 2
done



INSTALL_FIREWALLD_PLAYBOOK_LOCATION="${ANSIBLE_PLAYBOOKS_LOCATION}/install_firewall_for_all_nodes.yml"
CLUSTER_NODES_PREQUISITES_PLAYBOOK_LOCATION="${ANSIBLE_PLAYBOOKS_LOCATION}/cluster_nodes_prerequisites.yml"
MASTER_NODE_PREQUISITES_PLAYBOOK_LOCATION="${ANSIBLE_PLAYBOOKS_LOCATION}/master_node_prerequisites.yml"
WORKER_NODE_PREQUISITES_PLAYBOOK_LOCATION="${ANSIBLE_PLAYBOOKS_LOCATION}/worker_node_prerequisites.yml"


# write the environment variables to the all.yml file
yq e ".network_plugin = \"$NETWORK_PLUGIN\" " -i $ANSIBLE_ENVIRONMENT_FILE
yq e ".load_balancer = \"$LOAD_BALANCER\" " -i $ANSIBLE_ENVIRONMENT_FILE


# install firewall for all nodes
ansible-playbook -i $ANSIBLE_INVENTORY_FILE $INSTALL_FIREWALLD_PLAYBOOK_LOCATION

# install prerequisites for master nodes
# install general prerequisites for all nodes
ansible-playbook -i $ANSIBLE_INVENTORY_FILE $MASTER_NODE_PREQUISITES_PLAYBOOK_LOCATION & ansible-playbook -i $ANSIBLE_INVENTORY_FILE $CLUSTER_NODES_PREQUISITES_PLAYBOOK_LOCATION


# install prerequisites for worker nodes
# ansible-playbook -i $ANSIBLE_INVENTORY_FILE $WORKER_NODE_PREQUISITES_PLAYBOOK_LOCATION


print_label "Done Installing prerequisites for cluster nodes" 2
