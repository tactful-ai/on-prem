# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

  config.vm.provision "shell", path: "bootstrap.sh"

  NodeCount = 3

  # Kubernetes Nodes
  (1..NodeCount).each do |i|
    config.vm.define "k8s-node#{i}" do |node|
      node.vm.box = "bento/ubuntu-20.04"
      node.vm.hostname = "k8s-node#{i}.example.com"
      node.vm.network "private_network", ip: "192.168.56.1#{i}"
      node.vm.provider "virtualbox" do |v|
        v.name = "k8s-node#{i}"
        v.memory = 2048
        v.cpus = 2
      end
    end
  end

end
