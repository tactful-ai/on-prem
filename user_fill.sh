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


# select the docker version that compatible with you os and the k8s
# to know the used k8s version you can run
docker_version="23.0.6"


################################# Services Section #################################

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

# do you want to install redis
INSTALL_REDIS="yes"
