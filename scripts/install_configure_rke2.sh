#!/bin/bash

# Load the information from the separate file
source config.sh
source ./user_fill.sh


DISABLE_FIREWALLD_ONREDHAT_SYSTEM_PLAYBOOK_FILE="${ANSIBLE_PLAYBOOKS_LOCATION}/disable_firewalld_on_redhat_system.yml"
ansible-playbook -i $ANSIBLE_INVENTORY_FILE $DISABLE_FIREWALLD_ONREDHAT_SYSTEM_PLAYBOOK_FILE

mkdir -p $CLUSTER_FILES_LOCATION

MASTER_CONFIG=$CLUSTER_FILES_LOCATION/Master.yml
CLUSTER_TOKEN_LOCATION=$CLUSTER_FILES_LOCATION/rke2_token
CLUSTER_CONFIG_LOCATION=$CLUSTER_FILES_LOCATION/kube_config_cluster.yml
MASTER_PLAYBOOK=${ANSIBLE_PLAYBOOKS_LOCATION}/install_rke2_master.yml
RKE2_ADDONS_LOCATION=${PWD}/RKE2_addons


# Remove the existing YAML file if it exists
if [ -f "$MASTER_CONFIG" ]; then
    rm "$MASTER_CONFIG"
fi

# Get the IP address from the first node_info entry
master_node="${node_info[0]}"
IFS='|' read -ra info <<< "$master_node"
export ip_address="${info[0]}"

echo "" > "$MASTER_CONFIG"

yq e ".write-kubeconfig-mode = \"0644\"" -i $MASTER_CONFIG
yq e '.["tls-san"] += [env(ip_address)]' -i $MASTER_CONFIG
yq e ".[\"cni\"] += [\"$NETWORK_PLUGIN\"]" -i $MASTER_CONFIG

yq e ".node-name = \"master-node\"" -i $MASTER_CONFIG
yq e ".node-taint[0] = \"CriticalAddonsOnly=true:NoExecute\"" -i $MASTER_CONFIG

yq e ".cluster-cidr = \"${CLUSTER_CIDR}\"" -i $MASTER_CONFIG

yq e ".service-cidr = \"${SERVICE_CLUSTER_IP_RANGE}\"" -i $MASTER_CONFIG

yq e ".cluster-dns  = \"${CLUSTER_DNS_SERVER}\"" -i $MASTER_CONFIG



mkdir -p $ADDONS_DIRECTORY


# copy the addons from local to the server
yq e ".RKE2_ADDONS_LOCATION = \"$(calculate_relative_path $ANSIBLE_PLAYBOOKS_LOCATION $RKE2_ADDONS_LOCATION)\"" -i $ANSIBLE_ENVIRONMENT_FILE

# copy the addons from local to the server
yq e ".ADDONS_DIRECTORY = \"$(calculate_relative_path $ANSIBLE_PLAYBOOKS_LOCATION $ADDONS_DIRECTORY)\"" -i $ANSIBLE_ENVIRONMENT_FILE

# copy the cluster config and token from local to the server
yq e ".MASTER_CONFIG = \"$(calculate_relative_path $ANSIBLE_PLAYBOOKS_LOCATION $MASTER_CONFIG)\" " -i $ANSIBLE_ENVIRONMENT_FILE

# copy the cluster config and token from local to the server
yq e ".CLUSTER_TOKEN_LOCATION = \"$(calculate_relative_path $ANSIBLE_PLAYBOOKS_LOCATION $CLUSTER_TOKEN_LOCATION)\" " -i $ANSIBLE_ENVIRONMENT_FILE
yq e ".CLUSTER_CONFIG_LOCATION = \"$(calculate_relative_path $ANSIBLE_PLAYBOOKS_LOCATION $CLUSTER_CONFIG_LOCATION)\" " -i $ANSIBLE_ENVIRONMENT_FILE



mkdir -p $RKE2_ADDONS_LOCATION


cat <<EOF > $RKE2_ADDONS_LOCATION/helm-chart-config.yaml
apiVersion: helm.cattle.io/v1
kind: HelmChartConfig
metadata:
  name: rke2-ingress-nginx
  namespace: kube-system
spec:
  valuesContent: |-
    controller:
      kind: Deployment
      ingressClassResource:
        default: true
      publishService:
        enabled: true
      service:
        enabled: true
EOF


ansible-playbook -i $ANSIBLE_INVENTORY_FILE $MASTER_PLAYBOOK

yq e ".clusters[0].cluster.server = \"https://${ip_address}:6443\" " -i $CLUSTER_CONFIG_LOCATION


YAML_FILE=$CLUSTER_FILES_LOCATION/worker.yml
WORKERS_PLAYBOOK=${ANSIBLE_PLAYBOOKS_LOCATION}/install_rke2_worker.yml
WORKER_CONFIG=$CLUSTER_FILES_LOCATION/worker.yml


# Remove the existing YAML file if it exists
if [ -f "$YAML_FILE" ]; then
    rm "$YAML_FILE"
fi

# Create a YAML file with server and token fields
cat <<EOL > "$YAML_FILE"
server: https://$ip_address:9345
token: $(cat $CLUSTER_TOKEN_LOCATION)
EOL

# Use yq to validate and format the YAML file
yq eval '.' -i "$YAML_FILE"

yq e ".node-name = \"Worker-node\"" -i $YAML_FILE
yq e ".with-node-id  = \"true\"" -i $YAML_FILE


yq e ".WORKER_CONFIG = \"$(calculate_relative_path $ANSIBLE_PLAYBOOKS_LOCATION $WORKER_CONFIG)\" " -i $ANSIBLE_ENVIRONMENT_FILE


ansible-playbook -i $ANSIBLE_INVENTORY_FILE $WORKERS_PLAYBOOK

mkdir ~/.kube
cp $CLUSTER_FILES_LOCATION/kube_config_cluster.yml ~/.kube/config
chmod 600 /root/.kube/config

# Number of nodes expected to be in "Ready" state
expected_nodes_count=$num_nodes

# Number of retries
retries=500

# Delay between retries (in seconds)
delay=5

all_nodes_ready=false  # Initialize the variable as false

for ((i = 0; i < retries; i++)); do
    # Execute the kubectl command to get node status
    nodes_status=$(kubectl get nodes --no-headers)

    # Count the number of nodes in the "Ready" state
    ready_count=$(echo "$nodes_status" | awk '$2 == "Ready" { count++ } END { print count }')

    echo "Number of nodes in 'Ready' state: $ready_count"

    # Check if all nodes are in the "Ready" state
    total_nodes=$(echo "$nodes_status" | wc -l)
    if [ "$ready_count" -eq "$total_nodes" ]; then
        echo "All nodes are ready."
        all_nodes_ready=true  # Set the variable to true
        break
    fi

    # Sleep for the specified delay before the next retry
    sleep $delay
done

# Check if all nodes are ready; if not, throw an error
if [ "$all_nodes_ready" = false ]; then
    echo "Error: Not all nodes are ready."
    exit 1
fi
