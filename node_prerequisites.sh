#!/bin/bash

# Load the information from the separate file
source config.sh

# Delete existing SSH key pair
# rm -f ~/.ssh/id_rsa*

# Generate SSH key pair without passphrase
# ssh-keygen -t rsa -b 2048 -N "" -f ~/.ssh/id_rsa

# Read the generated public key
public_key=$(cat ~/.ssh/id_rsa.pub)

# Loop through the node_info array
for ((i=0; i<num_nodes; i++)); do
    node="${node_info[$i]}"
    IFS='|' read -ra info <<< "$node"

    ip_address="${info[0]}"
    root_password="${info[1]}"
    user="${info[2]}"


    echo "Start preparing node $ip_address"


    # Copy public key to the remote node
    sshpass -p "$root_password" ssh "$user@$ip_address" "echo '$public_key' >> ~/.ssh/authorized_keys"



    # Run commands as root user using 'sudo'
    sshpass -p "$root_password" ssh -o PubkeyAuthentication=no -tt -i ~/.ssh/id_rsa "$user@$ip_address" << EOF
        sudo -i


        swapoff -a; sed -i '/swap/d' /etc/fstab



        cat >>/etc/sysctl.d/kubernetes.conf<<EOL
            net.bridge.bridge-nf-call-ip6tables = 1
            net.bridge.bridge-nf-call-iptables = 1
EOL
        sysctl --system



        sudo apt-get update

        sudo apt install docker.io -y

        sudo snap install docker

        docker --version


        exit

        exit
        exit
EOF

    echo "Preparation completed for node $ip_address"
done
