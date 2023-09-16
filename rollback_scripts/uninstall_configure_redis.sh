#!/bin/bash

# Define the Redis namespace
REDIS_NAMESPACE="redis-system"

# Uninstall the Redis Helm release
echo "Uninstalling Redis..."
helm uninstall my-redis --namespace "${REDIS_NAMESPACE}"

# Delete the Redis namespace
echo "Deleting the Redis namespace..."
kubectl delete namespace "${REDIS_NAMESPACE}"

echo "Rollback completed."
