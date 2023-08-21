#!/bin/bash

# Load the information from the separate file
source config.sh

# Check if RKE is already installed
if ! command -v rke &>/dev/null; then
    echo "RKE is not installed. Installing RKE..."

    # Update package index
    echo $sudo_password | sudo apt update

    # Install required packages
    sudo apt install -y wget

    # Download the rke binary
    RKE_VERSION="v1.4.8"  # this is lts
    wget "https://github.com/rancher/rke/releases/download/$RKE_VERSION/rke_linux-amd64" -O rke
    chmod +x rke

    # Move the rke binary to a location in your PATH
    sudo mv rke /usr/local/bin/

    # Verify the installation
    rke --version
else
    echo "RKE is already installed."
fi

source ./generate_cluster_configuration_file.sh

# Deploy the Kubernetes cluster using rke
rke up --config cluster.yml

# Verify cluster deployment
kubectl get nodes
kubectl get pods --all-namespaces
