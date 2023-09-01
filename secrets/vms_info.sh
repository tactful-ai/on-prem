#!/bin/bash

# --------------------- main machine secrets Section ------------------

sudo_password="password for jumping machine"


# --------------------- Nodes secrets Section ------------------

# it can be PASSWORD=0 or SSH_KEY=1
CONNECTION_WAY=1

# Node information array
declare -a node_info

# Populate the node_info array with node information
# node_info[0]="ip_address|password|user|node_name" in case of using password
# node_info[0]="ip_address|ssh_key_path|user|node_name" in case of using ssh key
node_info[0]="xxx.xx.xx.xx|password|remote_machine_username|node_name"
node_info[0]="xxx.xx.xx.xx|password|remote_machine_username|node_name"

# if the machines require changeing the password the newpassword will be
NEW_MACHINES_PASSWORD="newpassword"


# Number of nodes
num_nodes=${#node_info[@]}
