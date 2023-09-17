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
   - [prometheus](#prometheus)

## Scripts & Functionality
## change_default_password.sh

This script changes the default password for multiple nodes in the cluster. It updates the SSH passwords for each node.
./change_default_password.sh

   Functionality: This script is responsible for changing the default SSH passwords on multiple nodes within the cluster. It updates the SSH passwords for each specified node based on the provided information in the user_fill.sh and config.sh files.

   Usage: When executed, the script will iterate through the nodes, connect to each one, and change the SSH password as specified in the configuration files.

## generate_cluster_configuration_file.sh

This script generates a cluster configuration file (cluster.yml) for RKE/RKE2 based on node information and user-defined settings.
./generate_cluster_configuration_file.sh

Functionality: This script generates a cluster configuration file (cluster.yml) required for setting up a Kubernetes cluster using either RKE (Rancher Kubernetes Engine) or RKE2 (Rancher Kubernetes Engine 2). It constructs the cluster configuration based on user-defined settings and node information.

Usage: Running this script will create a cluster.yml file in the cluster_configuration folder with the necessary configuration for your Kubernetes cluster. Users can customize this file before deploying the cluster.


## generate_inventory.sh

This script generates an Ansible inventory file for managing the cluster nodes with Ansible.
./generate_inventory.sh

Functionality: This script generates an Ansible inventory file (inventory.yml) that defines the cluster nodes. This inventory file is used for managing and provisioning nodes with Ansible.

Usage: Execute this script to create an inventory.yml file in the root directory, which lists the nodes and their details.

## install_configure_cert_manager.sh

This script installs Cert-Manager, a certificate management solution, in the Kubernetes cluster.
./install_configure_adminer.sh

Functionality: This script automates the installation of Cert-Manager, a certificate management solution, into the Kubernetes cluster. It downloads the Cert-Manager CRDs (Custom Resource Definitions) and deploys the Helm chart with user-defined settings.

Usage: Execute this script to install Cert-Manager in your cluster, enabling certificate issuance and management.

## install_configure_k8s_dashboard.sh

This script installs the Kubernetes Dashboard in the cluster and retrieves the admin user token.
./install_configure_k8s_dashboard.sh

Functionality: This script installs the Kubernetes Dashboard, a web-based UI for managing and monitoring your Kubernetes cluster. It deploys necessary Kubernetes resources and fetches an admin user token for dashboard access.

Usage: Run this script to set up the Kubernetes Dashboard in your cluster, making it easier to manage Kubernetes resources.

## install_configure_longhorn.sh

This script installs Longhorn, a cloud-native distributed storage solution, in the Kubernetes cluster.
./install_configure_longhorn.sh

Functionality: This script automates the installation of Longhorn, a distributed storage solution for Kubernetes, in the cluster. It uses Helm to deploy Longhorn and waits for the Longhorn pods to become "Running."

Usage: Execute this script to set up Longhorn, providing persistent storage capabilities for your cluster applications.

## install_configure_metalLB.sh

This script installs MetalLB, a load balancer for bare-metal Kubernetes clusters.
./install_configure_metalLB.sh

Functionality: This script installs MetalLB, a load balancer for bare-metal Kubernetes clusters. It adds Helm repositories, deploys MetalLB using Helm, and configures IP address pools.

Usage: Run this script to enable load balancing capabilities for your bare-metal Kubernetes cluster.


## install_configure_rancher_dashboard.sh

This script installs Rancher, a Kubernetes management platform, in the cluster.
./install_configure_rancher_dashboard.sh

Functionality: This script installs Rancher, a Kubernetes management platform, into the cluster. It adds Helm repositories, creates a Rancher namespace, and deploys Rancher with specified settings.

Usage: Run this script to deploy Rancher and use it as a management platform for your Kubernetes clusters.


##  install_configure_prometheus_and_grafana.sh

This script installs Prometheus and Grafana for monitoring and visualization in the Kubernetes cluster.
./install_configure_prometheus_and_grafana.sh

Functionality: This script installs Prometheus and Grafana for monitoring and visualization in the Kubernetes cluster. It configures various settings, such as Grafana password and Kubernetes version override.

Usage: Execute this script to set up monitoring and visualization tools in your cluster, allowing you to monitor cluster health and applications.

## install_configure_redis.sh

This script installs Redis in the Kubernetes cluster.
./install_configure_redis.sh

Functionality: This script installs Redis in the Kubernetes cluster using Helm. It creates the redis-system namespace and installs the Redis Helm chart with user-defined values.

Usage: Execute this script to set up Redis in your cluster, providing a high-performance, in-memory data store.


##  install_configure_rke1.sh and install_configure_rke2.sh

These scripts deploy a Kubernetes cluster using RKE (Rancher Kubernetes Engine) or RKE2 (Rancher Kubernetes Engine 2) and configure various settings.
./install_configure_rke1.sh # For RKE
./install_configure_rke2.sh # For RKE2

Functionality: These scripts deploy a Kubernetes cluster using RKE (Rancher Kubernetes Engine) or RKE2 (Rancher Kubernetes Engine 2). They automate the entire cluster creation process, including node setup and cluster configuration.

Usage: Choose the appropriate script based on whether you want to use RKE1 or RKE2, and run it to create a Kubernetes cluster.

## install_configure_adminer.sh

Functionality: This script automates the installation of Adminer, a web-based database management tool, into the Kubernetes cluster. It performs tasks such as creating a namespace, adding Helm repositories, and installing the Adminer Helm chart.

Usage: Run this script to install Adminer in your cluster, providing a convenient web interface for database management.



## jump_server_prerequisites.sh

This script installs prerequisites on a jump server to prepare it for managing the Kubernetes cluster.
./jump_server_prerequisites.sh

Functionality: This script installs prerequisites on a jump server to prepare it for managing the Kubernetes cluster. It installs Ansible and other required tools.

Usage: Execute this script to prepare a jump server for managing the Kubernetes cluster.


## node_prerequisites.sh

This script installs prerequisites on the cluster nodes, including SSH key setup and network configurations.
./node_prerequisites.sh

Functionality: This script installs prerequisites on the cluster nodes, including setting up SSH keys, configuring network settings, and preparing the nodes for cluster deployment.

Usage: Run this script to ensure that the cluster nodes are ready for cluster deployment and management.

These scripts and configurations collectively automate the deployment and management of a Kubernetes cluster, making it easier to set up and maintain an on-premises Kubernetes environment. Users can execute these scripts according to their requirements and customize configurations as needed.


## Folders

### Addons Folder:

Function: The addons folder likely contains additional configurations, scripts, or Kubernetes manifests (YAML files) that extend the functionality of your cluster. These can include custom applications or services to be deployed on the Kubernetes cluster.
Interaction: Individual scripts may refer to this folder to fetch and apply specific addon configurations or manifests during the cluster setup process. For instance, an RKE script may deploy Helm charts from this folder to install addons like Ingress controllers, monitoring tools, or other custom resources.

### Cluster_configuration Folder:

Function: The cluster_configuration folder typically stores the generated cluster configuration file (cluster.yml) produced by the generate_cluster_configuration_file.sh script. This configuration file contains critical information about the cluster's nodes, settings, and more.
Interaction: The generate_cluster_configuration_file.sh script creates and populates the cluster.yml file within this folder. Other cluster deployment scripts, like the RKE or RKE2 installation scripts, may read this file to configure the cluster according to the specified settings.

### Playbooks Folder:

Function: The playbooks folder contains Ansible playbooks and inventory files used for provisioning and managing cluster nodes. These playbooks automate various tasks on cluster nodes, such as installing prerequisites, changing SSH passwords, and more.
Interaction: Scripts that require Ansible for node setup, like jump_server_prerequisites.sh, node_prerequisites.sh, and some cluster deployment scripts, use these playbooks. The inventory files within this folder define the target nodes for Ansible operations.

### MelalLB Folder:
MetalLB Configuration:

Function: The MetalLB folder may contain configuration files specific to MetalLB, such as metallb_config.yaml or similar, where you define how IP addresses are allocated and what IP address pools to use.

Interaction with Scripts:

The install_configure_metalLB.sh script interacts with the MetalLB folder to:
Add the MetalLB Helm repository: This script likely uses Helm, a Kubernetes package manager, to install MetalLB.
Install and configure MetalLB in your Kubernetes cluster based on the configurations provided in the metallb_config.yaml file.
Set up MetalLB's components to manage the allocation of external IP addresses within your cluster.
IP Address Pool Configuration:

Function: MetalLB requires you to specify IP address pools from which it can allocate external IP addresses for services.

Contents and Interaction:

The ip_address_pool.yaml file in the MetalLB folder is likely used to define the range of IP addresses that MetalLB can use.
Interaction with Scripts:

The install_configure_metalLB.sh script may reference the ip_address_pool.yaml file to:
Extract the IP address range specified in the file.
Configure MetalLB to allocate IP addresses from this range for services that require external access.

L2 Advertisement Configuration:
Function: In some cases, MetalLB might need to send Layer 2 (L2) advertisements to your network infrastructure to announce the availability of IP addresses.

Contents and Interaction:

The L2Advertisement.yaml file could contain configurations related to L2 advertisements.
Interaction with Scripts:

The install_configure_metalLB.sh script may apply the configurations in the L2Advertisement.yaml file to ensure that MetalLB can properly advertise IP addresses on your network, if necessary.

### Redis Folder:

Function: The redis folder appears to store specific configurations, possibly for Redis deployment in your cluster. This folder may contain Redis Helm chart values or custom Redis configurations.
Interaction: The install_configure_redis.sh script accesses the resources within this folder to install and configure Redis in the Kubernetes cluster. It likely uses Helm to deploy Redis with the specified values and settings.

### Prometheus Folder:

Function: The prometheus folder likely contains configurations and resources related to Prometheus, which is an open-source monitoring and alerting toolkit designed for reliability and scalability. Prometheus collects and stores time-series data from various sources and allows you to query and visualize this data.

Contents and Interaction:

Prometheus Configuration: The folder may contain Prometheus configuration files (e.g., prometheus.yml) specifying data sources, scrape targets, alerting rules, and other settings.

Alerting Rules: You might find alerting rules files (e.g., alert.rules) defining conditions that trigger alerts.
Service Discovery Config: If you're using service discovery, there could be service discovery configuration files (e.g., prometheus_sd_config.yml) for dynamically discovering targets to scrape.

Custom Metrics: Any custom metrics or exporters specific to your cluster monitoring needs may be stored here.
Interaction with Scripts:

The install_configure_prometheus_and_grafana.sh script likely references the prometheus folder to:
Apply the Prometheus configuration to the cluster, defining what metrics to scrape and how often.
Load alerting rules into Prometheus to trigger alerts based on predefined conditions.
Set up service discovery to dynamically discover and monitor new targets as they are added to the cluster.
Configure any custom Prometheus settings needed for your specific monitoring requirements.

### Grafana Folder:

Function: The grafana folder is probably used to store configurations and resources related to Grafana, a popular open-source platform for monitoring and observability. Grafana provides a user-friendly interface for visualizing and exploring data, making it an excellent complement to Prometheus.

Contents and Interaction:

Dashboard Configuration: This folder may contain JSON or YAML files that define Grafana dashboards, including panels, queries, and visualizations.

Datasource Configuration: Grafana needs to be configured to connect to data sources like Prometheus. You may find datasource configuration files (e.g., grafana_datasource.yml) here.

Custom Plugins: If you're using custom Grafana plugins or integrations, their configurations or resources may be stored in this folder.
Interaction with Scripts:

The install_configure_prometheus_and_grafana.sh script likely interacts with the grafana folder to:
Import predefined Grafana dashboards and datasources to visualize data from Prometheus.
Configure Grafana to connect to Prometheus as a data source, enabling it to query and display metrics.
Customize Grafana settings, such as authentication, user roles, and other Grafana-specific configurations.
Optionally install and configure Grafana plugins or extensions to enhance its functionality.

### RKE2_addons Folder:

Function: The RKE2_addons folder could contain additional configurations or resources related to RKE2 cluster deployment. RKE2 is known for its simplicity and often allows adding custom resources.
Interaction: Scripts responsible for deploying RKE2 clusters, such as install_configure_rke2.sh, may leverage this folder to apply custom configurations or settings specific to RKE2.

### dstny.sh (Destination Script):

Function: The dstny.sh script, referred to as the "Destination Script," appears to be a central script that orchestrates the deployment and management of your Kubernetes cluster. It likely serves as an entry point for the overall cluster setup process.
Interaction: dstny.sh interacts with other scripts in your repository, calling them as needed to execute specific tasks. It may use the generate_cluster_configuration_file.sh script to generate the cluster configuration, invoke cluster deployment scripts like RKE or RKE2 scripts, and apply additional configurations or addons from folders like addons or RKE2_addons.
In summary, the folders in your repository serve as resource directories and configuration storage for various scripts. These scripts work together, orchestrated by dstny.sh, to automate the deployment and management of your Kubernetes cluster. The folders provide essential files and settings required for the cluster setup process, making it more organized and maintainable.


## TESTS

### test_distributed_storage.sh
Purpose: This script tests the resilience of a distributed storage setup by simulating scenarios where data is written to and read from persistent volumes (PVs) and persistent volume claims (PVCs) in a Kubernetes cluster.

Description:

The script creates a Kubernetes namespace for testing ($NAMESPACE) and sets up a PVC with ReadWriteMany access mode.
It deploys a pod (first-pod) that writes data to the PVC and checks if the data is written successfully.
After deleting the first-pod, it deploys a second pod (second-pod) on a different node that attempts to read the data written by the first pod.
The script validates whether the second pod can read the data from the PVC, demonstrating storage resilience.
Usage: You can document how to run this test script and any prerequisites for the test cluster or components.

Cleanup: Include instructions on how to clean up resources created during the test.

## test_dynamic_provisioning.sh
Purpose: This script tests dynamic provisioning of persistent volumes by creating a shared PVC and two pods that can read and write to it.

Description:

The script creates a Kubernetes namespace ($NAMESPACE) and deploys a shared PVC ($PVC_NAME) with ReadWriteMany access mode.
It deploys two pods (pod1 and pod2) in the same namespace that mount the shared PVC and perform read and write operations on it.
The script validates if data written by one pod can be read by the other, demonstrating dynamic provisioning.
Usage: Document how to run this test script and any prerequisites for dynamic provisioning support.

Cleanup: Include instructions for cleaning up resources after the test.

## test_metallb.sh
Purpose: This script tests the functionality of MetalLB, a load balancer for Kubernetes, by deploying a simple web application and checking its accessibility via a LoadBalancer service.

Description:

The script creates a Kubernetes namespace ($NAMESPACE) and deploys a simple web application (web-app) with two replicas.
It exposes the web application using a Service with type LoadBalancer, allowing external access via MetalLB.
The script waits for a LoadBalancer IP to be assigned and tests the web application's accessibility from a pod within the namespace.
Usage: Document how to run this script and any prerequisites related to MetalLB.

Cleanup: Explain how to clean up resources after testing MetalLB functionality.

## test_network_policy.sh
Purpose: This script tests Kubernetes network policies by creating and applying network policies that control communication between pods.

Description:

The script creates a Kubernetes namespace ($NAMESPACE) and deploys two pods (pod1 and pod2) in the same namespace.
It also deploys services for pod1 and pod2.
The script initially allows communication between the pods using a network policy.
Then, it applies a network policy to deny communication between the pods.
The script tests if communication between the pods succeeds before and after applying the network policy.
Usage: Document how to run this script and prerequisites related to network policies.

Cleanup: Explain how to clean up resources and remove network policies after testing.

## The Main Script(run_all_tests.sh)
Setting KUBECONFIG:

The script exports the KUBECONFIG environment variable to point to a Kubernetes cluster configuration file located in the cluster_configurations directory. This allows the script to interact with the specified Kubernetes cluster.
Running Test Scripts:

The script iterates through files in the tests directory, running each one if its filename starts with "test". This is accomplished using a for loop and the [[ "$test_script" == tests/test* ]] condition.
Each test script is sourced using source $test_script, which means that the code within the test scripts is executed in the current shell context.
Downloading and Installing Sonobuoy:

The script defines the URL for downloading Sonobuoy and specifies the installation directory (/usr/local/bin) for Sonobuoy.
It checks if Sonobuoy is already installed by looking for its executable in the specified installation directory.
If Sonobuoy is not installed, the script downloads the Sonobuoy binary, extracts it from the archive, makes it executable, and moves it to the installation directory.
Creating the Output Directory:

The script creates an output directory ($OUTPUT_DIR) where Sonobuoy test results will be stored. It uses the mkdir -p command to create the directory if it doesn't exist.
Running Sonobuoy Tests:

The script uses the sonobuoy run command to initiate Sonobuoy tests. It specifies options like --wait to wait for the tests to complete and --plugin-env to pass environment variables to the tests. In this case, it's passing an environment variable e2e.E2E_EXTRA_ARGS=--allowed-not-ready-nodes=1.
Retrieving Results:

After the Sonobuoy tests are initiated, the script uses the sonobuoy retrieve command to fetch the test results and stores them in the specified output directory.
Extracting Results:

The script extracts the test results from the downloaded archives using tar xzf. It assumes that the results are stored in .tar.gz files in the output directory.
Completion Message:

Finally, the script prints a message indicating that the Sonobuoy tests are completed and provides the path to where the results are stored.

