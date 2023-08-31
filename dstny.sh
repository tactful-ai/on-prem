#!/bin/bash

source config.sh

source ./scripts/node_prerequisites.sh

source ./scripts/generate_cluster_configuration_file.sh

# Deploy the Kubernetes cluster using rke
rke up --config $CLUSTER_FILES_LOCATION/cluster.yml

chmod +r $CLUSTER_FILES_LOCATION/kube_config_cluster.yml

export KUBECONFIG=$CLUSTER_FILES_LOCATION/kube_config_cluster.yml

kubectl get nodes -o wide

kubectl get pods --all-namespaces

source ./scripts/install_configure_longhorn.sh

source ./scripts/install_configure_metalLB.sh

source scripts/install_configure_promethus_and_grafana.sh

source scripts/install_configure_redis.sh
