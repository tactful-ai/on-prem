#!/bin/bash

# Load the information from the separate file
source config.sh

YAML_FILE=$CLUSTER_YML

# Remove the existing YAML file if it exists
if [ -f "$YAML_FILE" ]; then
    rm "$YAML_FILE"
fi

# Create a new YAML file with initial content
echo "" > "$YAML_FILE"

# Set the cluster name
yq eval ".CLUSTER_NAME = \"${CLUSTER_NAME}\"" -i "$YAML_FILE"

# Start writing the cluster.yml content
yq eval '.nodes = []' -i "$YAML_FILE"

# Loop through the node_info array
for ((i=0; i<num_nodes; i++)); do
    node="${node_info[$i]}"
    IFS='|' read -ra info <<< "$node"

    ip_address="${info[0]}"
    user="${info[2]}"

    # Set node information
    yq eval ".nodes[$i].address = \"$ip_address\"" -i "$YAML_FILE"
    yq eval ".nodes[$i].port = \"22\"" -i "$YAML_FILE"
    yq eval ".nodes[$i].user = \"$user\"" -i "$YAML_FILE"
    yq eval ".nodes[$i].docker_socket = \"$DOCKER_PATH\"" -i "$YAML_FILE"
    yq eval ".nodes[$i].ssh_key_path = \"$SSH_KEY_PATH\"" -i "$YAML_FILE"
done

# Set roles for nodes
yq eval -i ".nodes[0].role += [\"controlplane\", \"etcd\"]" "$YAML_FILE"
for ((i=1; i<num_nodes; i++)); do
    yq eval -i ".nodes[$i].role += [\"worker\"]" "$YAML_FILE"
done

# Set hostname overrides
for ((i=0; i<num_nodes; i++)); do
    if [[ $i -eq 0 ]]; then
        yq eval -i ".nodes[$i].hostname_override = \"master\"" "$YAML_FILE"
    else
        yq eval -i ".nodes[$i].hostname_override = \"worker-node-$i\"" "$YAML_FILE"
    fi
done

# Set Kubernetes version
yq eval ".kubernetes_version = \"${KUBERNETES_VERSION}\"" -i "$YAML_FILE"

# Set docker version ignoring
yq eval ".ignore_docker_version = false" -i "$YAML_FILE"

# Set SSH key path and agent authorization
yq eval ".ssh_key_path = \"${SSH_KEY_PATH}\"" -i "$YAML_FILE"
yq eval ".ssh_agent_auth = ${SSH_AGENT_AUTH}" -i "$YAML_FILE"

# Set network plugin and options
yq eval ".network.plugin = \"${NETWORK_PLUGIN}\" | .network.options = {}" -i "$YAML_FILE"

# Set service configurations
yq eval '.services.etcd = {"uid": 0, "gid": 0} |
         .services."kube-api" = {"always_pull_images": false, "pod_security_policy": false, "service_cluster_ip_range": "10.43.0.0/16"} |
         .services."kube-controller" = {"cluster_cidr": "10.42.0.0/16", "service_cluster_ip_range": "10.43.0.0/16"} |
         .services.kubelet = {"cluster_domain": "cluster.local", "cluster_dns_server": "10.43.0.10", "fail_swap_on": true} |
         .services.scheduler = {"extra_args": {"v": 4}} |
         .services.kubeproxy = {"extra_args": {"v": 4}}' -i "$YAML_FILE"

# Set authentication strategy
yq eval '.authentication = {"strategy": "x509"}' -i "$YAML_FILE"

# Set authorization mode
yq eval '.authorization = {"mode": "rbac"}' -i "$YAML_FILE"

# Set Ingress provider and options
yq eval '.ingress = {"provider": "nginx", "options": {}}' -i "$YAML_FILE"

# Set DNS configurations
yq eval '.dns = {
  "provider": "coredns",
  "update_strategy":
  {
    "strategy": "RollingUpdate",
    "rollingUpdate":
    {
      "maxUnavailable": "20%",
       "maxSurge": "15%"
    }
  },
    "linear_autoscaler_params":
    {
    "cores_per_replica": 0.34,
    "nodes_per_replica": 3,
    "prevent_single_point_failure": true,
    "min": 1,
    "max": 2
  }
}' -i "$YAML_FILE"

# Set monitoring provider and strategy
yq eval '.monitoring = {"provider": "metrics-server", "update_strategy": {"strategy": "RollingUpdate"}}' -i "$YAML_FILE"

# Set empty addons
yq eval ".addons = \"\"" -i "$YAML_FILE"

# Set empty addons_include
yq eval '.addons_include = []' -i "$YAML_FILE"

echo "Generated $CLUSTER_YML"
