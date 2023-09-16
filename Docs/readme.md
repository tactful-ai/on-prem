# On-Premises Kubernetes Cluster Deployment Repository

This repository contains scripts and configuration files for deploying an on-premises Kubernetes cluster using RKE (Rancher Kubernetes Engine) or RKE2 (Rancher Kubernetes Engine 2). It also includes additional configurations and addons to enhance the functionality of the cluster.

## Table of Contents

1. [Scripts](#scripts)
   - [change_default_password.sh](#change_default_passwordsh)
   - [generate_cluster_configuration_file.sh](#generate_cluster_configuration_filesh)
   - [generate_inventory.sh](#generate_inventorysh)
   - [install_configure_adminer.sh](#install_configure_adminersh)
   - [install_configure_cert_manager.sh](#install_configure_cert_managersh)
   - [install_configure_k8s_dashboard.sh](#install_configure_k8s_dashboardsh)
   - [install_configure_longhorn.sh](#install_configure_longhornsh)
   - [install_configure_metalLB.sh](#install_configure_metallbsh)
   - [install_configure_prometheus_and_grafana.sh](#install_configure_prometheus_and_grafanash)
   - [install_configure_rancher_dashboard.sh](#install_configure_rancher_dashboardsh)
   - [install_configure_redis.sh](#install_configure_redissh)
   - [install_configure_rke1.sh](#install_configure_rke1sh)
   - [install_configure_rke2.sh](#install_configure_rke2sh)
   - [jump_server_prerequisites.sh](#jump_server_prerequisitessh)
   - [node_prerequisites.sh](#node_prerequisitessh)

2. [Folders](#folders)
   - [addons](#addons)
   - [cluster_configuration](#cluster_configuration)
   - [redis](#redis)
   - [playbooks](#playbooks)
   - [grafana](#grafana)

## Scripts
## change_default_password.sh

This script changes the default password for multiple nodes in the cluster. It updates the SSH passwords for each node.
./change_default_password.sh


## generate_cluster_configuration_file.sh

This script generates a cluster configuration file (cluster.yml) for RKE/RKE2 based on node information and user-defined settings.
./generate_cluster_configuration_file.sh

## generate_inventory.sh

This script generates an Ansible inventory file for managing the cluster nodes with Ansible.
./generate_inventory.sh

## install_configure_cert_manager.sh

This script installs Cert-Manager, a certificate management solution, in the Kubernetes cluster.
./install_configure_adminer.sh

## install_configure_k8s_dashboard.sh

This script installs the Kubernetes Dashboard in the cluster and retrieves the admin user token.
./install_configure_k8s_dashboard.sh

## install_configure_longhorn.sh

This script installs Longhorn, a cloud-native distributed storage solution, in the Kubernetes cluster.
./install_configure_longhorn.sh

## install_configure_metalLB.sh

This script installs MetalLB, a load balancer for bare-metal Kubernetes clusters.
./install_configure_metalLB.sh


## install_configure_rancher_dashboard.sh

This script installs Rancher, a Kubernetes management platform, in the cluster.
./install_configure_rancher_dashboard.sh


##  install_configure_prometheus_and_grafana.sh

This script installs Prometheus and Grafana for monitoring and visualization in the Kubernetes cluster.
./install_configure_prometheus_and_grafana.sh

## install_configure_redis.sh

This script installs Redis in the Kubernetes cluster.
./install_configure_redis.sh


##  install_configure_rke1.sh and install_configure_rke2.sh

These scripts deploy a Kubernetes cluster using RKE (Rancher Kubernetes Engine) or RKE2 (Rancher Kubernetes Engine 2) and configure various settings.
./install_configure_rke1.sh # For RKE
./install_configure_rke2.sh # For RKE2


## jump_server_prerequisites.sh

This script installs prerequisites on a jump server to prepare it for managing the Kubernetes cluster.
./jump_server_prerequisites.sh


## node_prerequisites.sh

This script installs prerequisites on the cluster nodes, including SSH key setup and network configurations.
./node_prerequisites.sh


## Folders

### addons Folder:

Function: The addons folder likely contains additional configurations, scripts, or Kubernetes manifests (YAML files) that extend the functionality of your cluster. These can include custom applications or services to be deployed on the Kubernetes cluster.
Interaction: Individual scripts may refer to this folder to fetch and apply specific addon configurations or manifests during the cluster setup process. For instance, an RKE script may deploy Helm charts from this folder to install addons like Ingress controllers, monitoring tools, or other custom resources.

### cluster_configuration Folder:

Function: The cluster_configuration folder typically stores the generated cluster configuration file (cluster.yml) produced by the generate_cluster_configuration_file.sh script. This configuration file contains critical information about the cluster's nodes, settings, and more.
Interaction: The generate_cluster_configuration_file.sh script creates and populates the cluster.yml file within this folder. Other cluster deployment scripts, like the RKE or RKE2 installation scripts, may read this file to configure the cluster according to the specified settings.

### playbooks Folder:

Function: The playbooks folder contains Ansible playbooks and inventory files used for provisioning and managing cluster nodes. These playbooks automate various tasks on cluster nodes, such as installing prerequisites, changing SSH passwords, and more.
Interaction: Scripts that require Ansible for node setup, like jump_server_prerequisites.sh, node_prerequisites.sh, and some cluster deployment scripts, use these playbooks. The inventory files within this folder define the target nodes for Ansible operations.

### redis Folder:

Function: The redis folder appears to store specific configurations, possibly for Redis deployment in your cluster. This folder may contain Redis Helm chart values or custom Redis configurations.
Interaction: The install_configure_redis.sh script accesses the resources within this folder to install and configure Redis in the Kubernetes cluster. It likely uses Helm to deploy Redis with the specified values and settings.

### grafana Folder:

Function: The grafana folder likely holds Grafana-related configurations, including dashboards, datasources, and custom settings. Grafana is often used for cluster monitoring and visualization.
Interaction: The install_configure_prometheus_and_grafana.sh script may reference this folder to set up Grafana dashboards, datasources, and other configurations within the Grafana instance deployed as part of your cluster monitoring stack.

### RKE2_addons Folder:

Function: The RKE2_addons folder could contain additional configurations or resources related to RKE2 cluster deployment. RKE2 is known for its simplicity and often allows adding custom resources.
Interaction: Scripts responsible for deploying RKE2 clusters, such as install_configure_rke2.sh, may leverage this folder to apply custom configurations or settings specific to RKE2.

### dstny.sh (Destination Script):

Function: The dstny.sh script, referred to as the "Destination Script," appears to be a central script that orchestrates the deployment and management of your Kubernetes cluster. It likely serves as an entry point for the overall cluster setup process.
Interaction: dstny.sh interacts with other scripts in your repository, calling them as needed to execute specific tasks. It may use the generate_cluster_configuration_file.sh script to generate the cluster configuration, invoke cluster deployment scripts like RKE or RKE2 scripts, and apply additional configurations or addons from folders like addons or RKE2_addons.
In summary, the folders in your repository serve as resource directories and configuration storage for various scripts. These scripts work together, orchestrated by dstny.sh, to automate the deployment and management of your Kubernetes cluster. The folders provide essential files and settings required for the cluster setup process, making it more organized and maintainable.

## Functionality


## change_default_password.sh

Functionality: This script is responsible for changing the default SSH passwords on multiple nodes within the cluster. It updates the SSH passwords for each specified node based on the provided information in the user_fill.sh and config.sh files.

Usage: When executed, the script will iterate through the nodes, connect to each one, and change the SSH password as specified in the configuration files.

## generate_cluster_configuration_file.sh

Functionality: This script generates a cluster configuration file (cluster.yml) required for setting up a Kubernetes cluster using either RKE (Rancher Kubernetes Engine) or RKE2 (Rancher Kubernetes Engine 2). It constructs the cluster configuration based on user-defined settings and node information.

Usage: Running this script will create a cluster.yml file in the cluster_configuration folder with the necessary configuration for your Kubernetes cluster. Users can customize this file before deploying the cluster.

## generate_inventory.sh

Functionality: This script generates an Ansible inventory file (inventory.yml) that defines the cluster nodes. This inventory file is used for managing and provisioning nodes with Ansible.

Usage: Execute this script to create an inventory.yml file in the root directory, which lists the nodes and their details.

## install_configure_adminer.sh

Functionality: This script automates the installation of Adminer, a web-based database management tool, into the Kubernetes cluster. It performs tasks such as creating a namespace, adding Helm repositories, and installing the Adminer Helm chart.

Usage: Run this script to install Adminer in your cluster, providing a convenient web interface for database management.

## install_configure_cert_manager.sh

Functionality: This script automates the installation of Cert-Manager, a certificate management solution, into the Kubernetes cluster. It downloads the Cert-Manager CRDs (Custom Resource Definitions) and deploys the Helm chart with user-defined settings.

Usage: Execute this script to install Cert-Manager in your cluster, enabling certificate issuance and management.

## install_configure_k8s_dashboard.sh

Functionality: This script installs the Kubernetes Dashboard, a web-based UI for managing and monitoring your Kubernetes cluster. It deploys necessary Kubernetes resources and fetches an admin user token for dashboard access.

Usage: Run this script to set up the Kubernetes Dashboard in your cluster, making it easier to manage Kubernetes resources.

## install_configure_longhorn.sh

Functionality: This script automates the installation of Longhorn, a distributed storage solution for Kubernetes, in the cluster. It uses Helm to deploy Longhorn and waits for the Longhorn pods to become "Running."

Usage: Execute this script to set up Longhorn, providing persistent storage capabilities for your cluster applications.

## install_configure_metalLB.sh

Functionality: This script installs MetalLB, a load balancer for bare-metal Kubernetes clusters. It adds Helm repositories, deploys MetalLB using Helm, and configures IP address pools.

Usage: Run this script to enable load balancing capabilities for your bare-metal Kubernetes cluster.

## install_configure_prometheus_and_grafana.sh

Functionality: This script installs Prometheus and Grafana for monitoring and visualization in the Kubernetes cluster. It configures various settings, such as Grafana password and Kubernetes version override.

Usage: Execute this script to set up monitoring and visualization tools in your cluster, allowing you to monitor cluster health and applications.

## install_configure_rancher_dashboard.sh

Functionality: This script installs Rancher, a Kubernetes management platform, into the cluster. It adds Helm repositories, creates a Rancher namespace, and deploys Rancher with specified settings.

Usage: Run this script to deploy Rancher and use it as a management platform for your Kubernetes clusters.

## install_configure_redis.sh

Functionality: This script installs Redis in the Kubernetes cluster using Helm. It creates the redis-system namespace and installs the Redis Helm chart with user-defined values.

Usage: Execute this script to set up Redis in your cluster, providing a high-performance, in-memory data store.

## install_configure_rke1.sh and install_configure_rke2.sh

Functionality: These scripts deploy a Kubernetes cluster using RKE (Rancher Kubernetes Engine) or RKE2 (Rancher Kubernetes Engine 2). They automate the entire cluster creation process, including node setup and cluster configuration.

Usage: Choose the appropriate script based on whether you want to use RKE1 or RKE2, and run it to create a Kubernetes cluster.

## jump_server_prerequisites.sh

Functionality: This script installs prerequisites on a jump server to prepare it for managing the Kubernetes cluster. It installs Ansible and other required tools.

Usage: Execute this script to prepare a jump server for managing the Kubernetes cluster.

## node_prerequisites.sh

Functionality: This script installs prerequisites on the cluster nodes, including setting up SSH keys, configuring network settings, and preparing the nodes for cluster deployment.

Usage: Run this script to ensure that the cluster nodes are ready for cluster deployment and management.

These scripts and configurations collectively automate the deployment and management of a Kubernetes cluster, making it easier to set up and maintain an on-premises Kubernetes environment. Users can execute these scripts according to their requirements and customize configurations as needed.



