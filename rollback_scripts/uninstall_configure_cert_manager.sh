#!/bin/bash

# Define the namespace where Cert-Manager is installed
CERT_MANAGER_NAMESPACE="cert-manager"

# Uninstall Cert-Manager using Helm
echo "Uninstalling Cert-Manager..."
helm uninstall cert-manager --namespace "${CERT_MANAGER_NAMESPACE}"

# Delete the Cert-Manager namespace
echo "Deleting the Cert-Manager namespace..."
kubectl delete namespace "${CERT_MANAGER_NAMESPACE}"

echo "Rollback completed."
