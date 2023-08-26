#!/bin/bash

source ./config.sh

helm repo add metallb https://metallb.github.io/metallb

helm --namespace metallb-system install --create-namespace metallb metallb/metallb

IP_ADDRESSES_POOL=$IP_ADDRESSES_POOL_LOCATION

# Load IP addresses from environment variable
IP_ADDRESSES_RANGES=($METALLB_IP_RANGES)
    
# Convert IP addresses to a comma-separated string
IP_LIST=$(IFS=,; echo "${IP_ADDRESSES[*]}")

# Remove the existing addresses array
yq eval --inplace 'del(.spec.addresses)' -i "$IP_ADDRESSES_POOL"

for range in "${METALLB_IP_RANGES[@]}"; do
    yq eval --inplace '.spec.addresses += ["'"${range}"'"]' -i "$IP_ADDRESSES_POOL"
done

kubectl apply -f ./MetalLB/ip_address_pool.yaml

kubectl apply -f ./MetalLB/L2Advertisement.yaml
