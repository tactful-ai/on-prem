#!/bin/bash
source config.sh


VALUES_FILE_LOCATION=$PROMETHEUS_GRAFANA_FILES_LOCATION/values.yaml
PROMTHUS_NAMESPACE="prometheus"

mkdir -p $PROMETHEUS_GRAFANA_FILES_LOCATION

source ./prometheus_grafana_files/generate_dashboards.sh

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

kubectl create namespace $MONITOR_NAMESPACE

yq eval --inplace '.namespaceOverride = "'"${MONITOR_NAMESPACE}"'"' -i "$VALUES_FILE_LOCATION"

yq eval --inplace '.kubeTargetVersionOverride = "'"${K8s_VERSION}"'"' -i "$VALUES_FILE_LOCATION"

yq eval --inplace '.grafana.service.type = "'"${GRFANA_SVC}"'"' -i "$VALUES_FILE_LOCATION"

yq eval --inplace '.grafana.adminPassword = "'"${GRAFANA_ADMIN_PASSWORD}"'"' -i "$VALUES_FILE_LOCATION"

for file in "$GRAFANA_CONFIG_MAPS_DIRECTORY"/*; do
    if [ -f "$file" ]; then
        echo $file
        kubectl apply -f $file -n $MONITOR_NAMESPACE
    fi
done


helm install $MONITOR_NAMESPACE prometheus-community/kube-prometheus-stack --namespace $MONITOR_NAMESPACE --values $VALUES_FILE_LOCATION --wait

service_link=$(get_service_info $MONITOR_NAMESPACE grafana)

add_service_to_readme "Grafana Link" $service_link $GRAFANA_ADMIN_PASSWORD
