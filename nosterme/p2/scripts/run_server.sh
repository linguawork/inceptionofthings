#!/bin/bash

# args = [ ServerIp ]

export INSTALL_K3S_EXEC="server --write-kubeconfig-mode 644 --node-ip $1"

wget -qO - https://get.k3s.io | sh

#-R (recursive) → Processes all YAML files in the given directory and its subdirectories.
#-f /vagrant/confs/apps → Specifies the directory containing the manifest files.
kubectl apply -Rf /vagrant/confs/apps
