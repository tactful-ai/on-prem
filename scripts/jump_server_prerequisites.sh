#!/bin/bash

# Load the information from the separate files
source ./user_fill.sh
source ./config.sh

# Install git if not installed
if ! command -v git &>/dev/null; then
    print_label "Installing git" 1
    # Check if the system is CentOS or Red Hat
    if [[ -f /etc/redhat-release ]]; then
      # CentOS/Red Hat
      sudo yum install -y git
    else
      # Ubuntu
      sudo apt update -y
      sudo apt install git -y
    fi
    print_label "Done installing git" 2
else
    print_label "git is already installed." 2
fi


# Install wget if not installed
if ! command -v wget &>/dev/null; then
    print_label "Installing wget" 1
    # Check if the system is CentOS or Red Hat
    if [[ -f /etc/redhat-release ]]; then
      # CentOS/Red Hat
      sudo yum install -y wget
    else
      # Ubuntu
      sudo apt update -y
      sudo apt install wget -y
    fi
    print_label "Done installing wget" 2
else
    print_label "wget is already installed." 2
fi


# Install yq if not installed
if ! command -v yq &>/dev/null; then
    print_label "Installing yq" 1
    wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq
    chmod +x /usr/bin/yq
    print_label "Done installing yq" 2
else
    print_label "yq is already installed." 2
fi

# Install Ansible if not installed
if ! command -v ansible &>/dev/null; then
    print_label "Installing Ansible" 1
    # Check if the system is CentOS or Red Hat
    if [[ -f /etc/redhat-release ]]; then
      # CentOS/Red Hat
    sudo dnf install -y ansible-core
    else
      # Ubuntu
      sudo apt-add-repository ppa:ansible/ansible -y
      sudo apt update -y
      sudo apt install ansible -y
    fi
    print_label "Done installing Ansible" 2
else
    print_label "Ansible is already installed." 2
fi

# generate inventory file for ansible
source ./scripts/generate_inventory.sh

if [ "$RKE_VERSION" = "rke1" ]; then
  echo "enable rke1"
  RKE_VERSION=$(curl -s https://api.github.com/repos/rancher/rke/releases | \
  grep -E '"tag_name": "v[0-9]+\.[0-9]+\.[0-9]+"' | \
  grep -v -E '"tag_name": "v[0-9]+\.[0-9]+\.[0-9]-rc[0-9]+"' | \
  head -n 1 | \
  cut -d '"' -f 4)
  if [ -z "$RKE_VERSION" ]; then
    echo "Error: Unable to fetch the latest RKE LTS version."
    exit 1
  fi
  yq e ".[].vars.rke_version = \"${RKE_VERSION}\" " -i $JUMP_SERVER_PLAYBOOK_LOCATION
  yq e ".[].vars.install_rke = true " -i $JUMP_SERVER_PLAYBOOK_LOCATION
  yq e ".[].vars.install_docker = true " -i $CLUSTER_NODES_PREQUISITES_PLAYBOOK_LOCATION
  yq e ".[].vars.docker_version = \"${docker_version}\" " -i $CLUSTER_NODES_PREQUISITES_PLAYBOOK_LOCATION
elif [ "$RKE_VERSION" = "rke2" ]; then
  echo "disable rke1"
  yq e ".[].vars.install_rke = false " -i $JUMP_SERVER_PLAYBOOK_LOCATION
  yq e ".[].vars.install_docker = false " -i $CLUSTER_NODES_PREQUISITES_PLAYBOOK_LOCATION
fi

# installing the ansible.posix community.general to ensure that the firewall and ufw modules are available
ansible-galaxy collection install ansible.posix community.general

# install prerequisites for jump server
ansible-playbook -i ./playbooks/inventory.yml ./playbooks/jump_server_prerequisites.yml
print_label "Done Installing prerequisites for jump server" 2
