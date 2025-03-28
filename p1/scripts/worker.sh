#!/bin/bash

# Set the colors for displaying information in the terminal

GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

# �reating an environment variable for installing the worker node
# https://docs.k3s.io/installation/configuration#configuration-file

#agent: This tells K3s that you want to install it as a worker node (also called an agent), not as a server (master).
#--server https://192.168.56.110:6443: Specifies the address of the master/server node where the worker should connect.
#-t $(cat /vagrant/token.env): The -t option means token. It’s providing the join token required for the worker to securely connect to the master.
# $(cat /vagrant/token.env) dynamically reads the token from the file /vagrant/token.env, which was previously copied by the master/server node.
# /vagrant is the synced folder, meaning it’s shared between host and VM, so the worker VM can access it.
# --node-ip=192.168.56.111: Sets the worker’s IP address explicitly.

if export INSTALL_K3S_EXEC="agent --server https://192.168.56.110:6443 -t $(cat /vagrant/token) --node-ip=192.168.56.111"; then
        echo -e "${GREEN}export INSTALL_K3S_EXEC SUCCEEDED${RESET}"
else
        echo -e "${RED}export INSTALL_K3S_EXEC FAILED${RESET}"
fi

# Install worker node
# https://docs.k3s.io/quick-start

if curl -sfL https://get.k3s.io | sh -; then
	echo -e "${GREEN}K3s WORKER installation SUCCEEDED${RESET}"
else
	echo -e "${RED}K3s WORKER installation FAILED${RESET}"
fi

# The command "sudo ip link" add eth1 type dummy creates a virtual network interface named eth1
# The command "sudo ip addr" add 192.168.56.111/24 dev eth1 assigns the IP address 192.168.56.111 with a subnet mask of /24
# The final part, sudo ip link set eth1 up, activates the eth1 interface.

if sudo ip link add eth1 type dummy && sudo ip addr add 192.168.56.111/24 dev eth1 && sudo ip link set eth1 up; then
echo -e "${GREEN}add eth1 SUCCEESSFULLY${RESET}"
else
echo -e "${RED}add eth1 FAILED${RESET}"
fi



# We delete the token for security, and also so that when restarting, a new token is used and not the previously created one
sudo rm /vagrant/token



