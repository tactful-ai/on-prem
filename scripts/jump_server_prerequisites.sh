#!/bin/bash

# Load the information from the separate files
source ./user_fill.sh
source ./config.sh

# chose the package manager based on the OS
package_manager=""
if [[ -f /etc/redhat-release ]]; then
    package_manager="yum"
elif [[ -f /etc/SuSE-release ]]; then
    package_manager="zypper"
elif [[ -f /etc/os-release ]]; then
    source /etc/os-release
    if [[ $ID == "ubuntu" || $ID == "debian" ]]; then
        package_manager="apt"
    elif [[ $ID == "sles" ]]; then
        package_manager="zypper"
    else
        echo "Unsupported package manager."
        exit 1
    fi
else
    echo "Unsupported package manager."
    exit 1
fi

# this part used to run and prequisites for the package manager or adding repositories for the packages
case $package_manager in
    "yum")
        ;;
    "zypper")
        sudo SUSEConnect -p PackageHub/15.5/x86_64
        ;;
    "apt")
        sudo apt-add-repository ppa:ansible/ansible -y
        ;;
    *)
        echo "Unsupported package manager."
        exit 1
        ;;
esac

# Function to check and install packages using the appropriate package manager
install_package() {

    # Check if the package is already installed
    if ! command -v $1 &>/dev/null; then
        print_label "Installing $1 using $package_manager" 1

        # Install the package using the detected package manager
        case $package_manager in
            "yum")
                sudo yum install -y $1
                ;;
            "zypper")
                sudo zypper install -y $1
                ;;
            "apt")
                sudo apt install -y $1
                ;;
            *)
                echo "Unsupported package manager."
                exit 1
                ;;
        esac

        print_label "Done installing $1" 2
    else
        print_label "$1 is already installed." 2
    fi
}

# Install git if not installed
install_package "git"


# Install wget if not installed
install_package "wget"

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
if [ $package_manager == "yum" ]; then
    sudo dnf install -y ansible-core
else
    install_package "ansible"
fi


# generate inventory file for ansible
source ./scripts/generate_inventory.sh

# install rke1 and get its latest verstion if required
#
if [ "$RKE_VERSION" = "rke1" ]; then
  RKE_VERSION=$(curl -s https://api.github.com/repos/rancher/rke/releases | \
  grep -E '"tag_name": "v[0-9]+\.[0-9]+\.[0-9]+"' | \
  grep -v -E '"tag_name": "v[0-9]+\.[0-9]+\.[0-9]-rc[0-9]+"' | \
  head -n 1 | \
  cut -d '"' -f 4)
  if [ -z "$RKE_VERSION" ]; then
    echo "Error: Unable to fetch the latest RKE LTS version."
    echo "Please enter the desired RKE version:"
    read RKE_VERSION
  fi

  yq e ".rke_version = \"$RKE_VERSION\" " -i $ANSIBLE_ENVIRONMENT_FILE
  yq e "install_rke = true " -i $ANSIBLE_ENVIRONMENT_FILE
  yq e "install_docker = true " -i $ANSIBLE_ENVIRONMENT_FILE
  yq e "docker_version = \"${docker_version}\" " -i $ANSIBLE_ENVIRONMENT_FILE
  
elif [ "$RKE_VERSION" = "rke2" ]; then
  yq e "install_rke = false " -i $ANSIBLE_ENVIRONMENT_FILE
  yq e "install_docker = false " -i $ANSIBLE_ENVIRONMENT_FILE
fi

# installing the ansible.posix community.general to ensure that the firewall and ufw modules are available
ansible-galaxy collection install ansible.posix community.general

# install prerequisites for jump server
ansible-playbook -i ./playbooks/inventory.yml ./playbooks/jump_server_prerequisites.yml
print_label "Done Installing prerequisites for jump server" 2
