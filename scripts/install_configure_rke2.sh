#!/bin/bash

ansible-playbook -i ./playbooks/inventory.yml ./playbooks/install_rke2_master.yaml

ansible-playbook -i ./playbooks/inventory.yml ./playbooks/install_rke2_worker.yaml
