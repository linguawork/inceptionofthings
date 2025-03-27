#!/bin/bash

# args = [ ServerIp ]

export INSTALL_K3S_EXEC="server --write-kubeconfig-mode 644 --node-ip $1"
#server Запускает K3s в режиме мастера (контролирует кластер, распределяет задачи).
#--node-ip указывает IP-адрес узла, на котором запускается k3s.
#$1 означает, что IP-адрес передаётся как первый аргумент скрипта

wget -qO - https://get.k3s.io | sh

# token in synced folder can be used by workers to connect
sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant/token
