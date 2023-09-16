#!/bin/bash


for i in {1..11000}; do
    echo "using port $i"
    ansible-playbook -i ./playbooks/inventory.yml ./playbooks/open-port.yml --extra-vars "port=$i"
    sleep 5
    kubectl top node
done
