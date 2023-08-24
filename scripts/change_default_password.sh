#!/bin/bash

source ./secrets/vms_info.sh

new_password="${NEW_MACHINES_PASSWORD}"

# Iterate over node_info array
for ((i = 0; i < num_nodes; i++)); do

    node=${node_info[$i]}

    IFS='|' read -ra node_data <<< "$node"
    ip_address="${node_data[0]}"
    password="${node_data[1]}"
    user="${node_data[2]}"
    node_name="${node_data[3]}"

    echo "Node $i:"
    echo "IP Address: $ip_address"
    echo "User: $user"
    echo "Node Name: $node_name"

    echo "Start changing password for node $ip_address"

    ssh-keyscan "$ip_address" >> ~/.ssh/known_hosts

    username=$user ip_address=$ip_address current_password=$password new_password=$new_password expect << 'EOS'
    set timeout 200
    spawn ssh $env(username)@$env(ip_address)
    sleep 1
    expect "Password:" { send "$env(current_password)\r" }
    sleep 1
    expect "*?assword" { send "$env(current_password)\r" }
    sleep 1
    expect "*?assword" { send "$env(new_password)\r" }
    sleep 1
    expect "*?assword" { send "$env(new_password)\r" }
    sleep 3
    send "exit\r"
    expect eof
EOS

    # Update the password in the node_info array
    node_info[$i]="$ip_address|$new_password|$user|$node_name"

    echo "Changing password completed for node $ip_address"
    echo
done
