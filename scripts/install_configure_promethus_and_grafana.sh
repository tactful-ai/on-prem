#!/bin/bash

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

kubectl create namespace prometheus

helm --namespace prometheus install stable prometheus-community/kube-prometheus-stack -n prometheus --wait

kubectl get secret stable-grafana -n prometheus -o jsonpath="{.data.admin-password}" | base64 --decode && echo

kubectl patch svc stable-grafana -n prometheus -p '{"spec": {"type": "NodePort"}}'
