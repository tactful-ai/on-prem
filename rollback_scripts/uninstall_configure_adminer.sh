#!/bin/bash

# Define the Adminer namespace
ADMINER_NAMESPACE="adminer"

# Uninstall Adminer using Helm
echo "Uninstalling Adminer..."
helm uninstall adminer --namespace "${ADMINER_NAMESPACE}"

# Delete the Adminer namespace
echo "Deleting the Adminer namespace..."
kubectl delete namespace "${ADMINER_NAMESPACE}"

echo "Rollback completed."
