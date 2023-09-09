#!/bin/bash

# Load the information from the separate files
source ./user_fill.sh
source ./config.sh

# install yq if not installed
if ! command -v yq &>/dev/null; then
    print_label "installing yq" 1
    wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq
    chmod +x /usr/bin/yq
    print_label "Done installing yq" 2
else
    print_label "YQ is already installed." 2
fi

# install ansible if not installed
if ! command -v ansible &>/dev/null; then
    print_label "installing ansible" 1
    sudo apt-add-repository ppa:ansible/ansible -y
    sudo apt update -y
    sudo apt install ansible -y
    print_label "Done installing ansible" 2
else
    print_label "ANSIBLE is already installed." 2
    echo "ANSIBLE is already installed."
fi

# generate inventory file for ansible
source ./scripts/generate_inventory.sh


if [ "$RKE_VERSION" = "rke1" ]; then
  echo "enable rke1"
  # RKE_VERSION=$(curl -s https://api.github.com/repos/rancher/rke/releases | \
  # grep -E '"tag_name": "v[0-9]+\.[0-9]+\.[0-9]+"' | \
  # grep -v -E '"tag_name": "v[0-9]+\.[0-9]+\.[0-9]-rc[0-9]+"' | \
  # head -n 1 | \
  # cut -d '"' -f 4)
RKE_VERSION="v1.0.4"
  if [ -z "$RKE_VERSION" ]; then
    echo "Error: Unable to fetch the latest RKE LTS version."
    exit 1
  fi
  yq e ".[].vars.rke_version = \"${RKE_VERSION}\" " -i $JUMP_SERVER_PLAYBOOK_LOCATION
  yq e ".[].vars.install_rke = true " -i $JUMP_SERVER_PLAYBOOK_LOCATION
elif [ "$RKE_VERSION" = "rke2" ]; then
  echo "disable rke1"
  yq e ".[].vars.install_rke = false " -i $JUMP_SERVER_PLAYBOOK_LOCATION
fi



# install prerequisites for jump server
ansible-playbook -i ./playbooks/inventory.yml ./playbooks/jump_server_prerequisites.yml
print_label "Done Installing prerequisites for jump server" 2
