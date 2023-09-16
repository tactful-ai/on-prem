#!/bin/bash

# let us define some notations
# main machine: the machine that will run the script
# remote nodes: the machine that will be configured by the main machine

# Node information array
declare -a node_info

# Populate the node_info array with node information
# node_info[0]="ip_address|password|user|node_name" in case of using password
# node_info[0]="ip_address|ssh_key_path|user|node_name" in case of using ssh key
node_info[0]="Node_IP|password|remote_machine_username"
node_info[1]="xxx.xx.xx.xx|password|remote_machine_username"
node_info[2]="xxx.xx.xx.xx|password|remote_machine_username"
node_info[3]="xxx.xx.xx.dxx|password|remote_machine_username"

# sudo password from main machine
sudo_password="12345678"

# if the machines require changeing the password the newpassword will be
NEW_MACHINES_PASSWORD="newpassword"

# connection way to the remote nodes
# it can be PASSWORD=0 or SSH_KEY=1
CONNECTION_WAY=1

# Number of nodes
num_nodes=${#node_info[@]}


# chose whicih rke version you want to install
# we have rke1, rke2
# rke1 is the old version of rke that use docker as container runtime
# rke2 is the new version of rke that use containerd as container runtime
RKE_VERSION="rke2"

# select the docker version that compatible with you os and the k8s
# to know the used k8s version you can run
docker_version="23.0.6"





################################# Services Section #################################

# chose certification manager you want
# we have cert-manager, None
# if you dont want to install one of them write NONE
CERT_MANAGER="cert-manager"

# chose storage system you want to install
# we have longhorn, none
# if you dont want to install one of them write NONE
STORAGE_SYSTEM="longhorn"

# chose load balancer system you want to install
# we have metallb, none
# if you dont want to install one of them write NONE
LOAD_BALANCER="metallb"

# chose monitoring system you want to install
# we have prometheus, none
# if you dont want to install one of them write NONE
MONITORING_SYSTEM="prometheus"

# do you want to install Rancher DashBoard
# if you dont want to install write yes
INSTALL_RANCHER_DASHBOARD="yes"

# do you want to install Adminer
# if you dont want to install write yes
INSTALL_ADMINER="yes"

# do you want to install redis
# if you dont want to install write yes
INSTALL_REDIS="yes"

# do you want install k8s-dashboard
INSTALL_DASHBOARD="yes"
