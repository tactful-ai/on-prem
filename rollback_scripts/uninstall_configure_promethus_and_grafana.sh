#!/bin/bash

# Source your configuration file
source config.sh

# Define the namespace and release name
MONITOR_NAMESPACE="prometheus"

# Define the location of the original values.yaml file (assuming you have a backup)
ORIGINAL_VALUES_FILE_LOCATION="/path/to/original/values.yaml"

# Uninstall the Helm release
helm uninstall $MONITOR_NAMESPACE --namespace $MONITOR_NAMESPACE

# Delete Kubernetes resources in the MONITOR_NAMESPACE
kubectl delete namespace $MONITOR_NAMESPACE

# Optionally, restore the values.yaml file to its original state
if [ -f "$ORIGINAL_VALUES_FILE_LOCATION" ]; then
  cp "$ORIGINAL_VALUES_FILE_LOCATION" "$VALUES_FILE_LOCATION"
  echo "Restored the original values.yaml file."
else
  echo "No original values.yaml file found, so it was not restored."
fi

echo "Rollback completed."
