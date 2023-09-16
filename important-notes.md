Address

The address directive will be used to set the hostname or IP address of the node. RKE must be able to connect to this address.
Internal Address

The internal_address provides the ability to have nodes with multiple addresses set a specific address to use for inter-host communication on a private network. If the internal_address is not set, the address is used for inter-host communication. The internal_address directive will set the address used for inter-host communication of the Kubernetes components, e.g. kube-apiserver and etcd. To change the interface used for the vxlan traffic of the Canal or Flannel network plug-ins please refer to the Network Plug-ins Documentation.

https://rke.docs.rancher.com/config-options/nodes


--------------------------------------------------------------

Kubernetes Version

For information on upgrading Kubernetes, refer to the upgrade section.

Rolling back to previous Kubernetes versions is not supported.


--------------------------------------------------------------

Listing Supported Kubernetes Versions

Please refer to the release notes of the RKE version that you are running, to find the list of supported Kubernetes versions as well as the default Kubernetes version. Note: RKE v1.x should be used.

You can also list the supported versions and system images of specific version of RKE release with a quick command.

$ rke config --list-version --all
v1.15.3-rancher2-1
v1.13.10-rancher1-2
v1.14.6-rancher2-1
v1.16.0-beta.1-rancher1-1

--------------------------------------------------------------

Add-Ons


https://rke.docs.rancher.com/config-options/add-ons

--------------------------------------------------------------


Private Registries


https://rke.docs.rancher.com/config-options/private-registries


--------------------------------------------------------------------------------

Bastion/Jump Host Configuration

https://rke.docs.rancher.com/config-options/bastion-host


--------------------------------------------------------------------------------
System Images


https://rke.docs.rancher.com/config-options/system-images

--------------------------------------------------------------------------------
Default Kubernetes Services

https://rke.docs.rancher.com/config-options/services

--------------------------------------------------------------------------------

After you launch the cluster, you cannot change your network provider. Therefore, choose which network provider you want to use carefully, as Kubernetes doesn’t allow switching between network providers. Once a cluster is created with a network provider, changing network providers would require you tear down the entire cluster and all its applications.

https://rke.docs.rancher.com/config-options/add-ons/network-plugins


--------------------------------------------------------------------------------

Indeed, RKE (Rancher Kubernetes Engine) offers a selection of network plug-ins that you can choose from when deploying your Kubernetes clusters. These network plug-ins help manage the networking aspects of your containers and pods within the cluster. Here's a brief overview of the network plug-ins that RKE provides:

    Flannel: Flannel is a simple and lightweight network plug-in that provides an overlay network for Kubernetes clusters. It assigns a subnet to each host and uses various encapsulation techniques (such as VXLAN or UDP) to enable communication between containers across different hosts. Flannel is known for its ease of setup and use.

    Calico: Calico is a network plug-in that offers both Layer 3 and Layer 2 networking. It focuses on providing advanced network policy enforcement and fine-grained security controls. Calico enables you to define network policies to control communication between pods, implementing security and network segmentation within the cluster.

    Canal: Canal is a combined network plug-in that utilizes components from both Calico and Flannel. It offers the network policy enforcement and security features of Calico while using Flannel's overlay network for pod-to-pod communication.

    Weave: Weave is another network plug-in option provided by RKE. It offers a range of networking features, including DNS, IP address management, and network encryption. Weave provides its own overlay network that facilitates communication between containers and pods across hosts.

--------------------------------------------------------------------------------


Configuring NGINX Ingress Controller

For the configuration of NGINX, there are configuration options available in Kubernetes. There are a list of options for the NGINX config map , command line extra_args and annotations.


https://github.com/kubernetes/ingress-nginx/blob/main/docs/user-guide/nginx-configuration/configmap.md

https://rke.docs.rancher.com/config-options/add-ons/ingress-controllers

--------------------------------------------------------------------------------

User-Defined Add-Ons


https://rke.docs.rancher.com/config-options/add-ons/user-defined-add-ons

--------------------------------------------------------------------------------

Adding and Removing Nodes

https://rke.docs.rancher.com/managing-clusters


--------------------------------------------------------------------------------
full example


https://rke.docs.rancher.com/example-yamls


--------------------------------------------------------------------------------

# Specify DNS provider (coredns or kube-dns)
dns:
  provider: coredns
  # Available as of v1.1.0
  update_strategy:
    strategy: RollingUpdate
    rollingUpdate:
      maxUnavailable: 20%
      maxSurge: 15%
  linear_autoscaler_params:
    cores_per_replica: 0.34
    nodes_per_replica: 4
    prevent_single_point_failure: true
    min: 2
    max: 3

--------------------------------------------------------------------------------

we need to open ports for rke
    Control Plane Node Ports:
        TCP 6443: Kubernetes API Server + + as outbound also

    Worker Node Ports:
        TCP 10250: Kubelet API (secure communication between control plane and worker nodes)
        TCP 10251: Kube-Scheduler
        TCP 10252: Kube-Controller-Manager

    Control Plane and Worker Node Ports:
        TCP 2379-2380: etcd (for cluster state storage)
        TCP 8472: Flannel (for networking)

    Load Balancer Ports (if using an external load balancer):
        TCP 80: HTTP API Server (for Rancher UI)
        TCP 443: HTTPS API Server (for Rancher UI)
        TCP 30776-32767: NodePort Services (if using NodePort type services)

--------------------------------------------------------------------------------

we need the internal ip of the nodes be diffrent

--------------------------------------------------------------------------------

https://docs.tigera.io/archive/v3.8/reference/node/configuration#interfaceinterface-regex
























kubectl patch svc rancher -n cattle-system -p '{"spec": {"type": "NodePort"}}'


