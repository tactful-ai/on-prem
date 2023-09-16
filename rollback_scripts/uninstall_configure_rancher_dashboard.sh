#!/bin/bash

# Define the Rancher namespace
RANCHER_NAMESPACE="cattle-system"

# Uninstall Rancher using Helm
echo "Uninstalling Rancher..."
helm uninstall rancher --namespace "${RANCHER_NAMESPACE}"

# Delete the Rancher namespace
echo "Deleting the Rancher namespace..."
kubectl delete namespace "${RANCHER_NAMESPACE}"

echo "Rollback completed."
