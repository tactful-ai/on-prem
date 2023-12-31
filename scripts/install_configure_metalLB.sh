#!/bin/bash

source ./config.sh

METALLB_NAMESPACE="metallb-system"

helm repo add metallb https://metallb.github.io/metallb

helm --namespace $METALLB_NAMESPACE install --create-namespace metallb metallb/metallb

METALB_FOLDER=$METALLB_FILES_LOCATION
IP_ADDRESSES_POOL=$METALB_FOLDER/ip_address_pool.yaml
L2ADVERTISEMENT_LOCATION=$METALB_FOLDER/L2Advertisement.yaml


# Convert IP addresses to a comma-separated string
IP_LIST=$(IFS=,; echo "${IP_ADDRESSES[*]}")

# Remove the existing addresses array
yq eval --inplace 'del(.spec.addresses)' -i "$IP_ADDRESSES_POOL"

for range in "${METALLB_IP_RANGES[@]}"; do
    yq eval --inplace '.spec.addresses += ["'"${range}"'"]' -i "$IP_ADDRESSES_POOL"
done

print_label "done installing and configuring metallb Now Wait 60 second for confiugre the IP_ADDRESSES_POOL " 2

sleep 60

kubectl apply -f $IP_ADDRESSES_POOL

kubectl apply -f $L2ADVERTISEMENT_LOCATION
