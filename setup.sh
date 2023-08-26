#!/bin/bash

# Function to confirm user choice
confirm_choice() {
    read -p "Do you want to $1? (y/n): " choice
    if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
        eval $2
    fi
}

# Install Git
confirm_choice "install Git" "sudo apt-get install git-all"

# Install Helm
confirm_choice "install Helm" '
sudo apt-get update
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
'

# Install VirtualBox (if needed)
confirm_choice "install VirtualBox" '
sudo apt-get update
sudo apt-get install virtualbox
sudo apt-get install virtualbox—ext-pack'

# Install Vagrant (if needed)
confirm_choice "install Vagrant" '
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vagrant'

# Install Docker
confirm_choice "install Docker" '
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=\"$(dpkg --print-architecture)\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
'

# Install Ansible
confirm_choice "install Ansible" '
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible'

# Install rke (if needed)
confirm_choice "install rke" '
version="INSERT_RKE_VERSION_HERE"
wget https://github.com/rancher/rke/releases/download/${version}/rke_linux-amd64
chmod +x rke_linux-amd64
sudo mv rke_linux-amd64 /usr/local/bin/rke
'

# Clone git repo for vagrantfile and kubernetes manifests
confirm_choice "Clone repo" "git clone https://github.com/tactful-ai/on-prem.git"

# Run "Vagrant up" (if needed)
confirm_choice "run 'Vagrant up'" "vagrant up"

# Start Ansible playbook (if needed)
confirm_choice "start Ansible playbook" "ansible-playbook -i ./ansible-playbook/inventory.yml ./ansible-playbook/setup.yml"

# Run "rke up" (if needed)
confirm_choice "run 'rke up'" "rke up"

# Copy Kubernetes config
confirm_choice "copy Kubernetes config" "cp kube_config_cluster.yml ~/.kube/config"

# Install Longhorn (if needed)
confirm_choice "install Longhorn" '
helm repo add longhorn https://charts.longhorn.io
helm repo update
helm install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace --version 1.5.1
kubectl -n longhorn-system get pod
'

# Apply Kubernetes manifests
confirm_choice "install ingress controller" 'kubectl apply -f longhorn-ingress.yml'
confirm_choice "install storage class" 'kubectl apply -f storageclass.yml'
confirm_choice "install PVC" 'kubectl apply -f pvc.yml'
confirm_choice "install NGINX test pod" 'kubectl apply -f pod.yml'
confirm_choice "install NGINX test deployment" 'kubectl apply -f deployment.yml'

# Apply Dashboard UI deployment
confirm_choice "install Dashboard UI deployment" "kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml"

# Apply Dashboard adminuser and rolebinding
confirm_choice "install Dashboard adminuser" "kubectl apply -f dashboard-adminuser.yaml"
confirm_choice "install Dashboard cluster role binding" "kubectl apply -f dashboard-clusterrolebinding.yaml"

# Generate token for dashboard UI
confirm_choice "Generate a token for Dashboard UI" ""kubectl -n kubernetes-dashboard create token admin-user"