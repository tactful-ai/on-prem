#!/bin/bash

kubectl create ns redis-system

helm install my-redis oci://registry-1.docker.io/bitnamicharts/redis --values ./redis-files/values.yaml --namespace redis-system
