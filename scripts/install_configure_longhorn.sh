#!/bin/bash

source ./config.sh
source ./secrets/vms_info.sh

NUMBER_OF_NODES=$((${#node_info[@]} - 1))

LONGHORN_VALUES_FILE=$LONGHORN_FILES_LOCATION/values.yaml

helm repo add longhorn https://charts.longhorn.io

helm repo update

helm show values longhorn/longhorn > $LONGHORN_VALUES_FILE

yq eval --inplace '.persistence.defaultClassReplicaCount = "'"${NUMBER_OF_NODES}"'"' -i "$LONGHORN_VALUES_FILE"

helm install longhorn longhorn/longhorn --namespace longhorn-system -f $LONGHORN_VALUES_FILE --atomic

while true; do
    RUNNING_PODS=$(kubectl get pods -n longhorn-system -o jsonpath='{.items[*].status.phase}' | tr ' ' '\n' | grep 'Running' | wc -l)
    TOTAL_PODS=$(kubectl get pods -n longhorn-system --no-headers | wc -l)

    if [ "$RUNNING_PODS" -eq "$TOTAL_PODS" ]; then
        echo "All pods are running."
        break
    else
        echo "Waiting for pods to be in the 'Running' state..."
        sleep 5
    fi
done

curl -sSfL https://raw.githubusercontent.com/longhorn/longhorn/v1.5.1/scripts/environment_check.sh | bash