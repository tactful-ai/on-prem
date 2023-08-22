#!/bin/bash

# Load the information from the separate file
source config.sh

# # Delete existing SSH key pair
# rm -f ~/.ssh/id_rsa*

# # Generate SSH key pair without passphrase
# ssh-keygen -t rsa -b 2048 -N "" -f ~/.ssh/id_rsa

# Read the generated public key
public_key=$(cat ~/.ssh/id_rsa.pub)

# Loop through the node_info array
for ((i=0; i<num_nodes; i++)); do
    node="${node_info[$i]}"
    IFS='|' read -ra info <<< "$node"

    ip_address="${info[0]}"
    password="${info[1]}"
    user="${info[2]}"



    echo "Start preparing node $ip_address"


    sshpass -p "$password" ssh "$user@$ip_address" "echo '$public_key' >> ~/.ssh/authorized_keys"

    ssh -tt -i ~/.ssh/id_rsa "$user@$ip_address" << EOF
        sudo -i
        echo '$public_key' >> ~/.ssh/authorized_keys
        exit
        exit
EOF

VERSION_STRING="5:20.10.20~3-0~ubuntu-jammy"
    # Run commands as root user using 'sudo'
    ssh -tt -i ~/.ssh/id_rsa "root@$ip_address" << EOF
        sudo -i


        swapoff -a; sed -i '/swap/d' /etc/fstab



#         cat >>/etc/sysctl.d/kubernetes.conf<<EOL
#             net.bridge.bridge-nf-call-ip6tables = 1
#             net.bridge.bridge-nf-call-iptables = 1
# EOL
        sysctl --system


        sudo systemctl stop docker
        sudo systemctl disable docker


        sudo apt-get purge docker-ce docker-ce-cli containerd.io



        sudo rm -rf /var/lib/docker
        sudo rm -rf /etc/docker

        sudo rm -f /etc/apt/sources.list.d/docker.list
        sudo rm -f /usr/share/keyrings/docker-archive-keyring.gpg

        sudo apt-get update
        sudo apt-get install ca-certificates curl gnupg

        sudo apt install docker.io

        docker -v

        # nc -l -p port 2379


        exit
        exit
EOF

    echo "Preparation completed for node $ip_address"
done
