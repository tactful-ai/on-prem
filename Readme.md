# Dstny engage On-Prem Quick Start Guide

This guide will help you quickly set up and run Your On-Prem Cluster. Follow the steps below to get started.

## Prerequisites

- **Jump Server**: You will need an Ubuntu 20.04 machine to serve as the jump server. This server will act as a central point for managing and configuring other machines in your environment.

- **Additional VMs**: You should have at least two additional Virtual Machines (VMs), each running Ubuntu 20.04. These VMs should have a minimum of 2 vCPUs and 4GB of RAM to ensure smooth operation of the Dstny engage On-Prem solution.


## Clone the Repository

First, clone this repository to your local machine:

```bash
git clone https://github.com/tactful-ai/on-prem.git
```

## Navigate to the Repository

Change your current directory to the cloned repository:

```bash
cd on-prem
```

### Switch to Root User (sudo -i)

To ensure proper permissions for the setup, become the root user using `sudo -i`:

```bash
sudo -i
```
make sure that you are root for all of the next steps.

### Copy SSH Key

Copy the SSH key for the specified machines to your `~/.ssh/key.pem`. Make sure to adjust the file path and permissions:

```bash
cp path/to/your/ssh_key.pem ~/.ssh/key.pem
chmod 400 ~/.ssh/key.pem
```

## Configure User Information

Edit the `user_fill.sh` file to add information about your machines. You can specify your machine details using one of the following formats:

- Password-based authentication:
  ```shell
  node_info[0]="ip_address|password|user|node_name"
  ```

- SSH key-based authentication:
  ```shell
  node_info[0]="ip_address|ssh_key_path|user|node_name"
  ```

Example:

```shell
node_info[0]="xxx.xx.xx.xx|password|remote_machine_username|node_name"
```



### Run the Setup Script

Now, you're ready to start the setup process. Run the following command:

```bash
bash dstny.sh
```

Watch the magic ✨✨✨.


## Dstny engage On-Prem  Available Services

Dstny engage On-Prem offers a selection of services and components that you can choose to install based on your specific requirements. Below are the available services and systems:

### Storage System

You can choose the storage system you want to install:

- **Longhorn**: A distributed block storage system for Kubernetes.

- **None**: If you don't want to install any storage system, select "None."

```shell
STORAGE_SYSTEM="longhorn"
```

### Load Balancer System

You can choose the load balancer system you want to install:

- **MetalLB**: A load balancer implementation for bare-metal Kubernetes clusters.

- **None**: If you don't want to install any load balancer system, select "None."

```shell
LOAD_BALANCER="metallb"
```

### Monitoring System

You can choose the monitoring system you want to install:

- **Prometheus**: An open-source monitoring and alerting toolkit designed for reliability and scalability. Note: Grafana is installed along with Prometheus.

- **None**: If you don't want to install any monitoring system, select "None."

```shell
MONITORING_SYSTEM="prometheus"
```

### Redis

You can choose whether or not to install Redis. If you want to install Redis, set the following option to "yes."

```shell
INSTALL_REDIS="yes"
```

Choose the services and systems that align with your deployment needs and set the corresponding options in your configuration before running the setup script.

# Dstny engage On-Prem Configuration Guide

The `config.sh` file allows you to configure various aspects of the Dstny engage On-Prem solution to match your specific requirements. This guide provides an overview of each section in the configuration file and what you can customize within them.

## Main Machine Info Section

In this section, you can customize basic information related to your main machine and the Ansible inventory.

- `ANSIBLE_INVENTORY_FILE`: Specify the path to the Ansible inventory file.

## RKE Section

This section is responsible for configuring the Rancher Kubernetes Engine (RKE).

- `CLUSTER_FILES_LOCATION`: Specify the location for the generated cluster configuration files.

- `CLUSTER_NAME`: Define the name for your Kubernetes cluster.

- `KUBERNETES_VERSION`: Set the desired Kubernetes version.

- `DOCKER_PATH`: Specify the path to the Docker socket.

- `NETWORK_PLUGIN`: Choose a network plugin (e.g., "canal").

- `SSH_KEY_PATH`: Define the path to your SSH key.

- `SSH_AGENT_AUTH`: Enable or disable SSH agent authentication.

- `RKE_VERSION`: Set the RKE version.

- `CLUSTER_CIDR`: Configure the cluster CIDR.

- `SERVICE_CLUSTER_IP_RANGE`: Define the service cluster IP range.

- `CLUSTER_DNS_SERVER`: Specify the DNS server for the cluster.

- `METALLB_IP_RANGES`: Configure MetalLB IP ranges (if using).

- `IP_ADDRESSES_POOL_LOCATION`: Set the location for MetalLB IP address pool configuration.

- `RKE_ADDONS_INCLUDE`: Specify URLs for RKE addons.

- `INGRESS_PROVIDER`: Choose the Ingress controller provider (e.g., "nginx").

- `INGRESS_NETWORK_MODE`: Configure the Ingress network mode.

- `ADDONS_DIRECTORY`: Define the directory for addons.

## Longhorn Section

This section is related to configuring Longhorn, a distributed block storage system for Kubernetes.

- `LONGHORN_FILES_LOCATION`: Specify the location for Longhorn files.

- `LONGHORN_STORAGE_CLASS_NAME`: Set the Longhorn storage class name.

## MetalLB Section

Here, you can configure MetalLB, a load balancer implementation for bare-metal Kubernetes clusters.

- `METALLB_FILES_LOCATION`: Specify the location for MetalLB files.

## Prometheus and Grafana Section

This section allows you to customize settings related to Prometheus and Grafana.

- `PROMETHEUS_GRAFANA_FILES_LOCATION`: Set the location for Prometheus and Grafana files.

- `K8s_VERSION`: Automatically derived from `KUBERNETES_VERSION`.

- `DASHBOARDS_DIRECTORY`: Specify the directory for Grafana dashboards.

- `MONITOR_NAMESPACE`: Set the monitoring namespace.

- `GRFANA_SVC`: Define the Grafana service type.

- `GRAFANA_ADMIN_PASSWORD`: Set the Grafana admin password.

- `GRAFANA_CONFIG_MAPS_DIRECTORY`: Specify the directory for Grafana config maps.


By customizing these sections, you can tailor the Dstny engage On-Prem solution to meet your specific infrastructure and configuration preferences.
