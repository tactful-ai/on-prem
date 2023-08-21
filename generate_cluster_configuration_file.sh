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


system_images:
  etcd: rancher/mirrored-coreos-etcd:v3.5.6
  alpine: rancher/rke-tools:v0.1.89
  nginx_proxy: rancher/rke-tools:v0.1.89
  cert_downloader: rancher/rke-tools:v0.1.89
  kubernetes_services_sidecar: rancher/rke-tools:v0.1.89
  kubedns: rancher/mirrored-k8s-dns-kube-dns:1.22.20
  dnsmasq: rancher/mirrored-k8s-dns-dnsmasq-nanny:1.22.20
  kubedns_sidecar: rancher/mirrored-k8s-dns-sidecar:1.22.20
  kubedns_autoscaler: rancher/mirrored-cluster-proportional-autoscaler:1.8.6
  coredns: rancher/mirrored-coredns-coredns:1.9.4
  coredns_autoscaler: rancher/mirrored-cluster-proportional-autoscaler:1.8.6
  nodelocal: rancher/mirrored-k8s-dns-node-cache:1.22.20
  kubernetes: rancher/hyperkube:v1.26.7-rancher1
  flannel: rancher/mirrored-flannel-flannel:v0.21.4
  flannel_cni: rancher/flannel-cni:v0.3.0-rancher8
  calico_node: rancher/mirrored-calico-node:v3.25.0
  calico_cni: rancher/calico-cni:v3.25.0-rancher1
  calico_controllers: rancher/mirrored-calico-kube-controllers:v3.25.0
  calico_ctl: rancher/mirrored-calico-ctl:v3.25.0
  calico_flexvol: rancher/mirrored-calico-pod2daemon-flexvol:v3.25.0
  canal_node: rancher/mirrored-calico-node:v3.25.0
  canal_cni: rancher/calico-cni:v3.25.0-rancher1
  canal_controllers: rancher/mirrored-calico-kube-controllers:v3.25.0
  canal_flannel: rancher/mirrored-flannel-flannel:v0.21.4
  canal_flexvol: rancher/mirrored-calico-pod2daemon-flexvol:v3.25.0
  weave_node: weaveworks/weave-kube:2.8.1
  weave_cni: weaveworks/weave-npc:2.8.1
  pod_infra_container: rancher/mirrored-pause:3.7
  ingress: rancher/nginx-ingress-controller:nginx-1.7.0-rancher1
  ingress_backend: rancher/mirrored-nginx-ingress-controller-defaultbackend:1.5-rancher1
  ingress_webhook: rancher/mirrored-ingress-nginx-kube-webhook-certgen:v20230312-helm-chart-4.5.2-28-g66a760794
  metrics_server: rancher/mirrored-metrics-server:v0.6.3
  windows_pod_infra_container: rancher/mirrored-pause:3.7
  aci_cni_deploy_container: noiro/cnideploy:5.2.7.1.81c2369
  aci_host_container: noiro/aci-containers-host:5.2.7.1.81c2369
  aci_opflex_container: noiro/opflex:5.2.7.1.81c2369
  aci_mcast_container: noiro/opflex:5.2.7.1.81c2369
  aci_ovs_container: noiro/openvswitch:5.2.7.1.81c2369
  aci_controller_container: noiro/aci-containers-controller:5.2.7.1.81c2369
  aci_gbp_server_container: noiro/gbp-server:5.2.7.1.81c2369
  aci_opflex_server_container: noiro/opflex-server:5.2.7.1.81c2369



addons: ""
addons_include: []
EOF

echo "Generated $CLUSTER_YML"
