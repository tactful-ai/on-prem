# Important Notes for Project On-Prem

These important notes are intended to provide crucial information about the "On-Prem" project. Please read and consider these notes carefully, especially if you plan to use this project in a production environment.

## Table of Contents
- [Important Notes for Project On-Prem](#important-notes-for-project-on-prem)
  - [Table of Contents](#table-of-contents)
  - [Latest Version of RKE1 and Docker Compatibility](#latest-version-of-rke1-and-docker-compatibility)
  - [Network Plugin and Load Balancer Limitations](#network-plugin-and-load-balancer-limitations)
  - [Limitation of Using Docker with RKE1](#limitation-of-using-docker-with-rke1)
    - [Limitations and Considerations with Docker](#limitations-and-considerations-with-docker)
      - [Production Challenges](#production-challenges)
      - [Security Issues](#security-issues)
    - [The RKE2 Solution](#the-rke2-solution)
  - [Known Issues and Limitations with RKE2](#known-issues-and-limitations-with-rke2)
    - [Firewalld conflicts with default networking](#firewalld-conflicts-with-default-networking)
    - [NetworkManager](#networkmanager)
    - [Istio in Selinux Enforcing System Fails by Default](#istio-in-selinux-enforcing-system-fails-by-default)
    - [Control Groups V2](#control-groups-v2)
    - [Calico with vxlan encapsulation](#calico-with-vxlan-encapsulation)
    - [Wicked](#wicked)
    - [Canal and IP exhaustion](#canal-and-ip-exhaustion)
    - [Ingress in CIS Mode](#ingress-in-cis-mode)
  - [Choosing Your Network Provider](#choosing-your-network-provider)
    - [Considerations](#considerations)
  - [Including Kubernetes Manifests by Default](#including-kubernetes-manifests-by-default)
    - [Using the "addons" Folder](#using-the-addons-folder)
    - [Including Additional Manifests with `RKE_ADDONS_INCLUDE`](#including-additional-manifests-with-rke_addons_include)

## Latest Version of RKE1 and Docker Compatibility

Before you start using the "On-Prem" project, it's essential to ensure that you are using the latest compatible version of RKE1 and Docker. We recommend following these steps:

1. **Check the Latest RKE1 Version:** Visit the [RKE1 Support Matrix](https://www.suse.com/suse-rke1/support-matrix/all-supported-versions/rke1-v1-26/) to find the latest supported version of RKE1. Make a note of this version number.

2. **Select the Appropriate Docker Version:** Based on the RKE1 version you've identified, consult the RKE1 documentation or release notes to determine the compatible Docker version. Ensure that you have the specified Docker version installed on your system.

3. **Update the User Configuration (user_fill.sh):** In the "user_fill.sh" file within your project, update the `docker_version` env to the target version.

## Network Plugin and Load Balancer Limitations

When deploying RKE1 or RKE2, the choice of the network plugin can significantly impact your cluster's behavior and capabilities. Additionally, the load balancing solution, such as MetalLB, may have limitations based on the chosen network plugin.

To assist you in making informed decisions, we recommend reviewing the network plugin options and limitations with MetalLB:

- **Network Plugin Options**: You can find information about various network plugins and their compatibility with RKE1 and RKE2 in the [RKE1 documentation](https://rke.docs.rancher.com/config-options/add-ons/network-plugins) and [RKE2 documentation](https://docs.rke2.io/install/network_options). Take into account your specific use case and requirements when selecting a network plugin.

- **MetalLB Limitations**: MetalLB is a popular load balancer solution for Kubernetes, but it may have limitations with certain network plugins. Refer to the [MetalLB documentation](https://metallb.universe.tf/installation/network-addons/) for details on these limitations and any workarounds or considerations.

Please carefully evaluate your network and load balancing needs before proceeding with your cluster setup. Choosing the right combination of the network plugin and load balancer is essential for a successful deployment of the "On-Prem" project.

## Limitation of Using Docker with RKE1

RKE1 (Rancher Kubernetes Engine 1) is designed to work seamlessly with Docker as its container runtime. Using Docker with RKE1 ensures compatibility and optimal performance. However, it's essential to be aware of certain limitations and considerations, especially in production environments.

### Limitations and Considerations with Docker

#### Production Challenges

- **Scalability:** While Docker is suitable for many use cases, managing large-scale containerized applications can be complex. Proper resource management and scalability planning are essential to avoid performance issues.

- **High Availability (HA):** Achieving high availability with Docker can require additional configurations and infrastructure considerations, especially when dealing with stateful applications.

#### Security Issues

- **Container Security:** Docker containers are subject to security vulnerabilities if not configured and managed correctly. Ensure that you follow best practices for container security, including regularly updating container images and addressing vulnerabilities promptly.

- **Exposure of Sensitive Data:** Misconfigurations in Docker images or containers can lead to the unintentional exposure of sensitive data, posing security risks.

- **Network Security:** Docker network configurations should be secure to prevent unauthorized access to containers and data.

### The RKE2 Solution

It's worth mentioning that RKE2 (Rancher Kubernetes Engine 2) adopts Containerd as its container runtime, which addresses some of the limitations and security concerns associated with Docker. Containerd is designed with a strong focus on security and performance, making it a viable alternative for Kubernetes workloads.

By using RKE2 with Containerd, you can benefit from improved container security and potentially simplified management of your Kubernetes clusters.

Before deploying RKE1 or RKE2 in production, carefully assess your containerization needs, consider the limitations and security challenges associated with Docker, and evaluate whether RKE2 with Containerd is a better fit for your requirements.

## Known Issues and Limitations with RKE2

This section highlights current known issues and limitations with RKE2 (Rancher Kubernetes Engine 2). If you encounter issues with RKE2 that are not documented here, please consider opening a new issue on the [RKE2 Known Issues and Limitations](https://docs.rke2.io/known_issues) page.

### Firewalld conflicts with default networking

Firewalld conflicts with RKE2's default Canal (Calico + Flannel) networking stack. To avoid unexpected behavior, firewalld should be disabled on systems running RKE2.

### NetworkManager

NetworkManager can manipulate the routing table for interfaces in the default network namespace, potentially interfering with the Container Networking Interface (CNI) configurations used by RKE2. It is highly recommended to configure NetworkManager to ignore Calico and Flannel-related network interfaces when installing RKE2 on a NetworkManager-enabled system.

### Istio in Selinux Enforcing System Fails by Default

RKE2, due to just-in-time kernel module loading, may face challenges when running Istio in Selinux enforcing mode. To allow Istio to run under these conditions, two steps are required: enabling CNI as part of the Istio install and manually editing the daemonset for CNI pods to include `securityContext.privileged: true`.

### Control Groups V2

RKE2 versions 1.19.5 and later ship with Containerd 1.4.x or later, which supports cgroups v2. However, older versions may require specific kernel parameter settings to work correctly.

### Calico with vxlan encapsulation

Calico may encounter a kernel bug when using vxlan encapsulation with checksum offloading enabled on the vxlan interface. The recommended workaround is to disable checksum offloading by default using the `ChecksumOffloadBroken=true` value in the Calico Helm chart.

### Wicked

Wicked, a network manager, can revert network configurations made by RKE2, potentially affecting the cluster's functionality. To prevent this, it is essential to enable ipv4 (and ipv6 for dual-stack) forwarding in sysctl configuration files.

### Canal and IP exhaustion

IP exhaustion issues may occur due to iptables not being installed or leaked lock files in the `/var/lib/cni/networks/k8s-pod-network` directory. These issues can lead to problems with pod creation and IP allocation.

### Ingress in CIS Mode

When RKE2 is run with a CIS profile, it applies network policies that can be restrictive for ingress. Additional network policies may need to be defined to allow access to ingress URLs.

## Choosing Your Network Provider

When launching your Kubernetes cluster, it's crucial to select your network provider carefully. Kubernetes does not allow for easy switching between network providers once a cluster is created. Once you have chosen a network provider and deployed your cluster with it, changing to a different network provider would require tearing down the entire cluster and all its applications.

### Considerations

Each network provider may have its own features, limitations, and compatibility with different Kubernetes add-ons and tools. Consider the following factors when choosing a network provider:

- **Compatibility:** Ensure that your chosen network provider is compatible with the Kubernetes version you intend to use and any additional add-ons or tools you plan to integrate into your cluster.

- **Network Policy Support:** Some network providers offer more advanced network policy support, which may be essential for your application security requirements.

- **Performance:** Evaluate the performance characteristics of the network provider, especially if you anticipate high traffic or resource-intensive workloads.

- **Community and Documentation:** Check for community support and documentation related to your chosen network provider. A strong community and comprehensive documentation can be invaluable when troubleshooting issues.

- **Ecosystem Compatibility:** Consider how your network provider aligns with other tools and services you intend to use within your Kubernetes ecosystem.

## Including Kubernetes Manifests by Default

To include specific Kubernetes manifests or configurations in your cluster by default during deployment, you can leverage the "addons" folder and the `RKE_ADDONS_INCLUDE` configuration.

### Using the "addons" Folder

1. **Pre-existing "addons" Folder:** A folder named "addons" is already created within your project directory or alongside your RKE configuration files.

2. **Add Your Manifests:** If you wish to deploy additional manifests along with your cluster, simply place the desired Kubernetes manifests or configuration files in the "addons" folder.

### Including Additional Manifests with `RKE_ADDONS_INCLUDE`

You can also include manifests from online by specifying them in the `RKE_ADDONS_INCLUDE` configuration within your RKE cluster configuration file. This allows you to include external configurations in your cluster deployment.

1. **Edit Your Cluster Configuration:** In your RKE cluster configuration file, set the `RKE_ADDONS_INCLUDE` configuration as an array of URLs or local file paths. For example:

```yaml
RKE_ADDONS_INCLUDE=(
    "https://example.com/manifests/external.yaml"
    ""
)
