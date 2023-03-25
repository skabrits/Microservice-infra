#!/bin/bash

# Getting Required IPs
IPADDR=$(ip a show eth1 | grep "inet " | awk '{print $2}' | cut -d / -f1)

# Launching server
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="777" INSTALL_K3S_VERSION="v1.21.14+k3s1" K3S_TOKEN=SECRET INSTALL_K3S_EXEC="--node-ip=${IPADDR} --flannel-backend=none --disable-network-policy --disable=traefik" sh -s - server --cluster-init --disable servicelb

# Adding configs for dev kubectl
mkdir -p /vagrant/configs
cp /etc/rancher/k3s/k3s.yaml /vagrant/configs/config
chmod a+r /vagrant/configs/config
sudo sed -i "s/127.0.0.1/$IPADDR/g" /vagrant/configs/config

# calico network plugin
sudo kubectl create -f "https://raw.githubusercontent.com/projectcalico/calico/v3.24.4/manifests/calico.yaml"

# Deploying metal-lb
sudo kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.3/manifests/namespace.yaml
sudo kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.3/manifests/metallb.yaml
sudo kubectl create -f /vagrant/manifests/configmap.yaml
