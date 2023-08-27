#!/bin/bash

source ./config.sh
source ./secrets/vms_info.sh

NUMBER_OF_NODES=${#node_info[@]}

STORAGE_CLASS_FILE=$LONGHORN_FILES_LOCATION/storageclass.yaml
LONGHORN_FILE=$LONGHORN_FILES_LOCATION/longhorn.yaml

yq eval --inplace '.parameters.numberOfReplicas = "'"${NUMBER_OF_NODES}"'"' -i "$STORAGE_CLASS_FILE"


yq eval --inplace '.metadata.name = "'"${LONGHORN_STORAGE_CLASS_NAME}"'"' -i "$STORAGE_CLASS_FILE"

kubectl apply -f "$LONGHORN_FILE"

kubectl apply -f "$STORAGE_CLASS_FILE"

kubectl patch storageclass longhorn  -p '{"metadata": {"annotations": {"storageclass.kubernetes.io/is-default-class": "true"}}}'
