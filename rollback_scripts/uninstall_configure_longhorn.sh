#!/bin/bash

# Define the Longhorn namespace
LONGHORN_NAMESPACE="longhorn-system"

# Uninstall Longhorn using Helm
echo "Uninstalling Longhorn..."
helm uninstall longhorn --namespace "${LONGHORN_NAMESPACE}"

# Delete the Longhorn namespace
echo "Deleting the Longhorn namespace..."
kubectl delete namespace "${LONGHORN_NAMESPACE}"

echo "Rollback completed."
