#!/bin/bash

source ./config.sh

helm repo add metallb https://metallb.github.io/metallb

helm --namespace metallb-system install --create-namespace metallb metallb/metallb --wait

METALB_FOLDER=$metallb_FILES_LOCATION
IP_ADDRESSES_POOL=$METALB_FOLDER/ip_address_pool.yaml
L2ADVERTISEMENT_LOCATION=$METALB_FOLDER/L2Advertisement.yaml


# Convert IP addresses to a comma-separated string
IP_LIST=$(IFS=,; echo "${IP_ADDRESSES[*]}")

# Remove the existing addresses array
yq eval --inplace 'del(.spec.addresses)' -i "$IP_ADDRESSES_POOL"

for range in "${METALLB_IP_RANGES[@]}"; do
    yq eval --inplace '.spec.addresses += ["'"${range}"'"]' -i "$IP_ADDRESSES_POOL"
done

kubectl apply -f $IP_ADDRESSES_POOL

kubectl apply -f $L2ADVERTISEMENT_LOCATION
