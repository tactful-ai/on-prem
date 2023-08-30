# Set up a Highly Available Kubernetes Cluster using Rancher RKE
Follow this documentation to set up a highly available Kubernetes cluster on __Ubuntu 20.04 LTS__ machines using Rancher's RKE.

This documentation guides you in setting up a cluster with three nodes all of which play master, etcd and worker role.

## Vagrant Environment
|Role|FQDN|IP|OS|RAM|CPU|
|----|----|----|----|----|----|
|Master|node1.example.com|192.168.56.11|Ubuntu 20.04|2G|2|
|Master, etcd, worker|node2.example.com|192.168.56.12|Ubuntu 20.04|2G|2|
|Master, etcd, worker|node3.example.com|192.168.56.13|Ubuntu 20.04|2G|2|

> * Password for the **root** account on all these virtual machines is **kubeadmin**
> * Perform all the commands as root user unless otherwise specified

## Pre-requisites
If you want to try this in a virtualized environment on your workstation
* Virtualbox installed
* Vagrant installed
* Host machine has atleast 8 cores
* Host machine has atleast 8G memory

## Bring up all the virtual machines
```
vagrant up
```

## Download RKE Binary
##### Download the latest release from the Github releases page
[Rancher RKE Releases - Github](https://github.com/rancher/rke/releases)

## Set up password less SSH Logins on all nodes
We will be using SSH Keys to login to root account on all the kubernetes nodes. I am not going to set a passphrase for this ssh keypair.
##### Create an ssh keypair on the host machine
```
ssh-keygen -t rsa -b 2048
```
##### Copy SSH Keys to all the kubernetes nodes
The root password is **kubeadmin**
```
ssh-copy-id root@172.16.16.101
ssh-copy-id root@172.16.16.102
ssh-copy-id root@172.16.16.103
```

## Prepare the kubernetes nodes (node1, node2, node3)
##### Disable Firewall
```
ufw disable
```
##### Disable swap
```
swapoff -a; sed -i '/swap/d' /etc/fstab
```
##### Update sysctl settings for Kubernetes networking
```
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
```
##### Install docker engine
```
{
  apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  apt update && apt install -y docker-ce=5:19.03.10~3-0~ubuntu-focal containerd.io
}
```

## Bring up Kubernetes cluster
##### Create cluster configuration
```
rke config
```
Once gone through this interactive cluster configuration, you will end up with cluster.yml file in the current directory.

##### Provision the cluster
```
rke up
```
Once this command completed provisioning the cluster, you will have cluster state file (cluster.rkestate) and kube config file (kube_config_cluster.yml) in the current directory.

## Downloading kube config to your local machine
On your host machine
```
mkdir ~/.kube
cp kube_config_cluster.yml ~/.kube/config
```

## Verifying the cluster
```
kubectl cluster-info
kubectl get nodes
kubectl get cs
```
## Installation ArgoCd
```
# install ArgoCD in k8s
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# access ArgoCD UI
kubectl get svc -n argocd
kubectl port-forward svc/argocd-server 8090:443 -n argocd

# login with admin user and below token :
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode && echo

# you can change and delete init password
```
Custom Resource Definition (CRD):
- In Kubernetes, a Custom Resource Definition (CRD) allows you to define custom resources with specific schemas that are not part of the core Kubernetes API. CRDs enable you to extend the Kubernetes API with your own types of resources. In the context of ArgoCD, the Application CRD defines a custom resource that represents the deployment and management of applications within the ArgoCD system.

- Application Custom Resource (CR):
The Application Custom Resource (CR) is an instance of the Application CRD. It defines the desired state of an application to be managed by ArgoCD. In your provided YAML manifest, you have defined an Application CR instance with specific settings for deploying your workload.

Let's break down the fields in your provided Application CR:

metadata: This section provides metadata about the Application CR instance, such as its name and namespace.

spec.project: Specifies the ArgoCD project to which this application belongs. Projects are used to organize and group applications in ArgoCD.

spec.source: Describes where the application source code is located. In this case, it points to a Git repository (repoURL) with a specific branch/tag (targetRevision) and a subdirectory (path) within the repository.

spec.destination: Specifies the Kubernetes cluster and namespace where the application should be deployed (server and namespace fields).

spec.syncPolicy: Defines the synchronization policy for the application:

syncOptions: Additional synchronization options. In your case, it specifies CreateNamespace=true, which means that if the namespace specified in destination does not exist, ArgoCD will create it.

automated: Defines automated synchronization options for self-healing and pruning:

selfHeal: If set to true, ArgoCD will automatically attempt to bring the application back to the desired state if there are any drifts.

prune: If set to false, ArgoCD will not delete any resources that are no longer defined in the application manifest.
--------------
# you can definitely replace `targetRevision: HEAD` with a specific Git tag to synchronize your application using a specific version of the code.

For example, if you have a Git tag named `v1.0.0` in your repository that you want to use, you can update the `targetRevision` field in your ArgoCD Application manifest like this:

yaml
```
source:
  repoURL: https://github.com/tactful-ai/on-prem.git
  targetRevision: v1.0.0
  path: manifests
```


Have Fun!!
