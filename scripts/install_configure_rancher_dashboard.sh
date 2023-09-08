#!/bin/bash

source config.sh

# Define the namespace where Rancher will be installed
RANCHER_NAMESPACE="cattle-system"

# Set the number of replicas for the Rancher Deployment
RANCHER_REPLICAS=3

# Step 1: Add the Helm Chart Repository
echo "Step 1: Adding the Helm Chart Repository..."
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

# Step 2: Create a Namespace for Rancher
echo "Step 2: Creating the Rancher namespace..."
kubectl create namespace "${RANCHER_NAMESPACE}"

# Step 3: Install Rancher with Helm
echo "Step 3: Installing Rancher with Helm..."
helm install rancher rancher-latest/rancher --namespace "${RANCHER_NAMESPACE}" --set hostname="${RANCHER_HOSTNAME}" --set replicas="${RANCHER_REPLICAS}" --wait

# Step 4: Verify that the Rancher server is successfully deployed
echo "Step 4: Verifying Rancher installation..."
kubectl -n "${RANCHER_NAMESPACE}" rollout status deploy/rancher

echo "Rancher installation complete!"
