#!/bin/bash

# Load the information from the separate file
source config.sh


# Add cluster name to the cluster.yml
echo "cluster_name: \"${CLUSTER_NAME}\"" > "$CLUSTER_YML"


# Start writing the cluster.yml content
echo "nodes:" >> "$CLUSTER_YML"

# Loop through the node_info array
for ((i=0; i<num_nodes; i++)); do
    node="${node_info[$i]}"
    IFS='|' read -ra info <<< "$node"

    ip_address="${info[0]}"
    user="root"

    echo "  - address: $ip_address" >> "$CLUSTER_YML"
    echo "    port: \"22\"" >> "$CLUSTER_YML"
    echo "    user: $user" >> "$CLUSTER_YML"
    echo "    docker_socket: $DOCKER_PATH" >> "$CLUSTER_YML"
    echo "    ssh_key_path: $SSH_KEY_PATH" >> "$CLUSTER_YML"

    # Role configuration
    echo "    role:" >> "$CLUSTER_YML"
    if [[ $i -eq 0 ]]; then
        echo "      - controlplane" >> "$CLUSTER_YML"
        echo "      - etcd" >> "$CLUSTER_YML"
    else
    echo "      - worker" >> "$CLUSTER_YML"
    fi


    # Hostname override configuration
    if [[ $i -eq 0 ]]; then
        echo "    hostname_override: master" >> "$CLUSTER_YML"
    else
        echo "    hostname_override: worker-node-$i" >> "$CLUSTER_YML"
    fi

    echo "" >> "$CLUSTER_YML"
done



# Append the rest of the configuration
cat << EOF >> "$CLUSTER_YML"

kubernetes_version: ${KUBERNETES_VERSION}

ignore_docker_version: false

ssh_key_path: ${SSH_KEY_PATH}

ssh_agent_auth: false

network:
  plugin: ${NETWORK_PLUGIN}
  options: {}

services:
  etcd:
    uid: 0
    gid: 0

  kube-api:
    always_pull_images: False
    pod_security_policy: false
    service_cluster_ip_range: 10.43.0.0/16
    # extra_args:
      # Add any additional kube-api configuration here

  kube-controller:
    cluster_cidr: 10.42.0.0/16
    service_cluster_ip_range: 10.43.0.0/16
    # extra_args:
      # Add any additional kube-controller configuration here

  kubelet:
    cluster_domain: cluster.local
    cluster_dns_server: 10.43.0.10
    fail_swap_on: true

  scheduler:
    extra_args:
    # Set the level of log output to debug-level
      v: 4

  kubeproxy:
    extra_args:
    # Set the level of log output to debug-level
      v: 4


authentication:
  strategy: x509

authorization:
  mode: rbac

# Ingress configuration with NGINX
ingress:
  provider: nginx
  options: {}

dns:
  provider: coredns
  update_strategy:
    strategy: RollingUpdate
    rollingUpdate:
      maxUnavailable: 20%
      maxSurge: 15%
  linear_autoscaler_params:
    cores_per_replica: 0.34
    nodes_per_replica: 3
    prevent_single_point_failure: true
    min: 1
    max: 2


# Specify monitoring provider (metrics-server)
monitoring:
  provider: metrics-server
  update_strategy:
    strategy: RollingUpdate

addons: ""
addons_include: []
EOF

echo "Generated $CLUSTER_YML"
