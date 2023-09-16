#!/bin/bash

# Source your configuration
source ./config.sh

# Step 1: Delete L2Advertisement configuration
kubectl delete -f $L2ADVERTISEMENT_LOCATION

# Step 2: Delete IP address pool configuration
kubectl delete -f $IP_ADDRESSES_POOL

# Step 3: Uninstall MetalLB
helm uninstall metallb --namespace metallb-system

# Step 4: Remove the Helm repository
helm repo remove metallb

echo "Rollback completed."
