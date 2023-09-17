#!/bin/bash

source ./user_fill.sh


# --------------------- main machine info Section ------------------

ANSIBLE_PLAYBOOKS_LOCATION="${PWD}/playbooks"
ANSIBLE_INVENTORY_FILE="${PWD}/playbooks/inventory.yml"
ANSIBLE_ENVIRONMENT_FILE="${PWD}/playbooks/group_vars/all.yml"
JUMP_SERVER_PLAYBOOK_LOCATION="${PWD}/playbooks/jump_server_prerequisites.yml"
CLUSTER_NODES_PREQUISITES_PLAYBOOK_LOCATION="${ANSIBLE_PLAYBOOKS_LOCATION}/cluster_nodes_prerequisites.yml"



# --------------------- RKE Section ------------------

# Specify the path for the generated cluster.yml file
CLUSTER_FILES_LOCATION="${PWD}/cluster_configurations"

CLUSTER_NAME="Dstny"

KUBERNETES_VERSION=$(rke config --list-version --all | sort -V | tail -n 1)

DOCKER_PATH="/var/run/docker.sock"

# LOOK AT IMPORTANT NOTE TO FIND ALL TYPES
# calico, canal and cilium for rke2
# calico, canal, weave and Flannel for rke1
NETWORK_PLUGIN="canal"


SSH_KEY_PATH="~/.ssh/id_rsa"
SSH_AGENT_AUTH=false

CLUSTER_CIDR="10.42.0.0/16"
SERVICE_CLUSTER_IP_RANGE="10.43.0.0/16"
CLUSTER_DNS_SERVER="10.43.0.10"


METALLB_IP_RANGES=(
    "10.0.0.100-10.0.0.110"
    "10.0.0.120-10.0.0.140"
)

IP_ADDRESSES_POOL_LOCATION="${PWD}/MetalLB-files/ip_address_pool.yaml"

RKE_ADDONS_INCLUDE=()


INGRESS_PROVIDER="nginx"
INGRESS_NETWORK_MODE="none"


ADDONS_DIRECTORY="${PWD}/addons"

# Define the hostname for Rancher
RANCHER_HOSTNAME="rancher.my.org"

RANCHER_SERVICE_TYPE="NodePort"

# --------------------- LONGHORN Section ------------------

LONGHORN_FILES_LOCATION="${PWD}/longhorn-files"

LONGHORN_STORAGE_CLASS_NAME="longhorn"


# --------------------- METALLB Section ------------------


METALLB_FILES_LOCATION="${PWD}/MetalLB-files/"


# --------------------- promthus and grafana Section ------------------

PROMETHEUS_GRAFANA_FILES_LOCATION="${PWD}/prometheus_grafana_files"

K8s_VERSION=$(echo "$KUBERNETES_VERSION" | grep -o 'v[0-9.]*')

DASHBOARDS_DIRECTORY="${PWD}/prometheus_grafana_files/dashboards"

MONITOR_NAMESPACE="monitoring"

GRFANA_SVC="NodePort"

GRAFANA_ADMIN_PASSWORD="waer1234"

GRAFANA_CONFIG_MAPS_DIRECTORY="${PWD}/prometheus_grafana_files/config_maps"


# --------------------- Output File Section ------------------

OUTPUT_FILE="${PWD}/output.md"


# --------------------- utils functions Section ------------------

print_label() {
    local text="$1"
    local color_code="0"  # Default color (white)

    # Check the second parameter for color
    if [ "$2" == "1" ]; then
        color_code="33"  # Yellow
    elif [ "$2" == "2" ]; then
        color_code="32"  # Green
    fi
    echo && echo && echo && echo
    echo -e "\e[${color_code}m====================================\e[0m"
    echo & echo
    echo -e "\e[${color_code}m$text\e[0m"
    echo & echo
    echo -e "\e[${color_code}m====================================\e[0m"
    echo && echo && echo && echo
}


# function to get the relative path between two paths
calculate_relative_path() {
    local source_path="$1"
    local target_path="$2"

    # Get the absolute paths of the directories
    local abs_source_path=$(realpath "$source_path")
    local abs_target_path=$(realpath "$target_path")

    # Calculate the relative path
    local common_part="$abs_source_path"
    local result=""

    while [[ "${abs_target_path#$common_part}" == "${abs_target_path}" ]]; do
        common_part="$(dirname "$common_part")"
        result="../$result"
    done

    result="${result}${abs_target_path#$common_part/}"

    echo "$result"
}


# Function to add a service entry to the README
add_service_to_readme() {
    local service_name="$1"
    local service_link="$2"
    local service_logging_key="$3"

    # Format the service information as a table row
    local table_row="| $service_name | $service_link |"

    if [ -n "$service_logging_key" ]; then
        table_row="$table_row $service_logging_key |"
    else
        table_row="$table_row - |"
    fi

    # Append the table row to the README file
    echo "$table_row" >> "$OUTPUT_FILE"
}


# Function to add custom text to the README
add_text_to_readme() {
    local custom_text="$1"
    echo "$custom_text" >> "$OUTPUT_FILE"
}

# Function to initialize the README file with cluster information
init_output_file() {
    # Initialize the README file
    echo "# You can Access the Services that Have installed throught the the link with key from the next Table" > "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"

    # Add a section for exposed services table header
    echo "## Exposed Services" >> "$OUTPUT_FILE"
    echo "| Service Name | Link | Logging Key/Token |" >> "$OUTPUT_FILE"
    echo "|--------------|------|-------------|" >> "$OUTPUT_FILE"
}

# Function to get the service link and type (LoadBalancer or NodePort)
get_service_info() {
    local namespace="$1"
    local service_name="$2"

    if [ -z "$service_name" ]; then
        # If service_name is not provided, find the first service of type LoadBalancer or NodePort in the namespace
        local kubectl_cmd="kubectl -n $namespace get svc -o json"
        local services_info="$(eval "$kubectl_cmd")"

        if [ -z "$services_info" ]; then
            echo "No services found in namespace: $namespace"
            return 1
        fi

        # Loop through the services to find the first LoadBalancer or NodePort service
        local service_type=""
        local load_balancer_ip=""
        local node_port=""

        while read -r service; do
            service_type="$(echo "$service" | jq -r '.spec.type')"

            if [ "$service_type" == "LoadBalancer" ]; then
                load_balancer_ip="$(echo "$service" | jq -r '.status.loadBalancer.ingress[0].ip')"
                if [ "$load_balancer_ip" != "null" ]; then
                    break
                fi
            elif [ "$service_type" == "NodePort" ]; then
                node_port="$(echo "$service" | jq -r '.spec.ports[0].nodePort')"
                if [ -n "$node_port" ]; then
                    break
                fi
            fi
        done <<< "$(echo "$services_info" | jq -c '.items[]')"

        if [ -z "$service_type" ]; then
            echo "No LoadBalancer or NodePort services found in namespace: $namespace"
            return 1
        fi

        if [ "$service_type" == "LoadBalancer" ]; then
            if [ "$load_balancer_ip" == "null" ]; then
                echo "LoadBalancer IP not available for any service in namespace: $namespace"
                return 1
            fi
            echo "http://$load_balancer_ip"
        elif [ "$service_type" == "NodePort" ]; then
            if [ -z "$node_port" ]; then
                echo "NodePort not available for any service in namespace: $namespace"
                return 1
            fi
            local node_ip_index=$(( RANDOM % ${#node_info[@]} ))
            local node_info_str="${node_info[$node_ip_index]}"
            IFS='|' read -ra node_info_arr <<< "$node_info_str"
            local node_ip="${node_info_arr[0]}"
            local node_username="${node_info_arr[2]}"
            echo "http://$node_ip:$node_port"
        fi
    else
        # If service_name is provided, find the specific service by name
        local kubectl_cmd="kubectl -n $namespace get svc $service_name -o json"
        local service_info="$(eval "$kubectl_cmd")"

        if [ -z "$service_info" ]; then
            echo "Service not found in namespace: $namespace"
            return 1
        fi

        local service_type
        if [ "$(echo "$service_info" | jq -r '.spec.type')" == "LoadBalancer" ]; then
            service_type="LoadBalancer"
        elif [ "$(echo "$service_info" | jq -r '.spec.type')" == "NodePort" ]; then
            service_type="NodePort"
        else
            echo "Unsupported service type for service: $service_name"
            return 1
        fi

        if [ "$service_type" == "LoadBalancer" ]; then
            local load_balancer_ip="$(echo "$service_info" | jq -r '.status.loadBalancer.ingress[0].ip')"
            if [ "$load_balancer_ip" == "null" ]; then
                echo "LoadBalancer IP not available for service: $service_name"
                return 1
            fi
            echo "http://$load_balancer_ip"
        elif [ "$service_type" == "NodePort" ]; then
            local node_port="$(echo "$service_info" | jq -r '.spec.ports[0].nodePort')"
            if [ -z "$node_port" ]; then
                echo "NodePort not available for service: $service_name"
                return 1
            fi
            local node_ip_index=$(( RANDOM % ${#node_info[@]} ))
            local node_info_str="${node_info[$node_ip_index]}"
            IFS='|' read -ra node_info_arr <<< "$node_info_str"
            local node_ip="${node_info_arr[0]}"
            local node_username="${node_info_arr[2]}"
            echo "http://$node_ip:$node_port"
        fi
    fi
}

