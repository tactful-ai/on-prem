#!/bin/bash

source ./config.sh
source ./user_fill.sh


# install longhorn prerquisites using absible
ansible-playbook -i ./playbooks/inventory.yml ./playbooks/longhorn_prerequisites.yml

curl -sSfL https://raw.githubusercontent.com/longhorn/longhorn/v1.5.1/scripts/environment_check.sh | bash

NUMBER_OF_NODES=$((${#node_info[@]} - 1))

LONGHORN_VALUES_FILE=$LONGHORN_FILES_LOCATION/values.yaml

helm repo add longhorn https://charts.longhorn.io

helm repo update

mkdir -p $LONGHORN_FILES_LOCATION

helm show values longhorn/longhorn > $LONGHORN_VALUES_FILE

yq eval --inplace '.persistence.defaultClassReplicaCount = "'"${NUMBER_OF_NODES}"'"' -i "$LONGHORN_VALUES_FILE"

kubectl create namespace longhorn-system

helm install longhorn longhorn/longhorn --namespace longhorn-system -f $LONGHORN_VALUES_FILE --atomic

while true; do
    RUNNING_PODS=$(kubectl get pods -n longhorn-system -o jsonpath='{.items[*].status.phase}' | tr ' ' '\n' | grep 'Running' | wc -l)
    TOTAL_PODS=$(kubectl get pods -n longhorn-system --no-headers | wc -l)

    if [ "$RUNNING_PODS" -ge "$((TOTAL_PODS - 3))" ]; then
        echo "The desired number of pods are running."
        break
    else
        echo "Waiting for pods to be in the 'Running' state..."
        sleep 5
    fi
done
