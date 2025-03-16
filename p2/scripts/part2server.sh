#!/bin/bash

# Update packages
sudo apt-get update -y

# Install dependencies
sudo apt-get install -y curl

# Install K3s (lightweight Kubernetes)
curl -sfL https://get.k3s.io | sh -
    
# Wait for K3s to be fully operational
sleep 10

# Ensure K3s is running
sudo systemctl enable k3s
sudo systemctl start k3s







    # Set up kubectl (if needed)
    mkdir -p $HOME/.kube
    sudo cp /etc/rancher/k3s/k3s.yaml $HOME/.kube/config
    sudo chown $(whoami):$(whoami) $HOME/.kube/config
    export KUBECONFIG=$HOME/.kube/config

    # Apply Kubernetes manifests
    kubectl apply -f /vagrant/deployments.yaml
    kubectl apply -f /vagrant/ingress.yaml
