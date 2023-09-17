#!/bin/bash

source ./config.sh

# Define the namespace where Adminer will be installed
ADMINER_NAMESPACE="adminer"

# Define the Helm chart name (replace with the actual chart name)
HELM_CHART="adminer"

# Step 1: Create the Adminer namespace (if it doesn't exist)
echo "Step 1: Creating the Adminer namespace..."
kubectl create namespace "${ADMINER_NAMESPACE}"

# Step 2: Add the Helm repository for Adminer (if not already added)
echo "Step 2: Adding the Helm repository for Adminer..."
helm repo add cetic https://cetic.github.io/helm-charts

# Step 3: Update the local Helm chart repository cache
echo "Step 3: Updating the Helm chart repository cache..."
helm repo update

# Step 4: Install Adminer using Helm
echo "Step 4: Installing Adminer using Helm..."
helm install adminer cetic/"${HELM_CHART}" --namespace "${ADMINER_NAMESPACE}" --wait

# Verify installation
echo "Verifying Adminer installation..."
kubectl get pods -n "${ADMINER_NAMESPACE}"

service_link=$(get_service_info $ADMINER_NAMESPACE)

add_service_to_readme "ADMINER Link" $service_link

echo "Adminer installation complete!"
