#!/bin/bash

IPADDR=$(ip a show eth1 | grep "inet " | awk '{print $2}' | cut -d / -f1)

curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="777" INSTALL_K3S_VERSION="v1.21.14+k3s1" INSTALL_K3S_EXEC="--node-ip=${IPADDR}" K3S_URL=https://master-01:6443 K3S_TOKEN=SECRET sh -

mkdir -p "~/.kube/"

cp /vagrant/configs/config "~/.kube/config"