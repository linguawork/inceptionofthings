#!/bin/bash

# Greet user 
echo "Hi there, areggie decided to run all the installations via bash script, 
we will install Vagrant, VB etc on Ubuntu JellyFish"



# Update package lists
echo "1 Updating and upgrading package lists..."
sudo apt update && sudo apt upgrade -y

# Install required dependencies
echo "2 Installing required dependencies: curl, wget, gnupg2"
sudo apt install -y curl wget gnupg2

echo "3 Adding HashiCorp's GPG Key..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg 

echo "4 Adding HashiCorp's Official APT Repository..."
sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list'
echo "4.1 Updating the package lists..."
sudo apt update

echo "5 Installing vagrant..."
sudo apt install vagrant -y

echo "The version of vagrant is: "
sudo vagrant --version



# Install VirtualBox
echo "Installing VirtualBox... after Vagrant"

# Update package lists
echo "1 Updating and upgrading package lists..."
sudo apt update && sudo apt upgrade -y

echo "2 Installing several packages on your system using apt, \
which is the package management tool \
used by Debian-based distributions like Ubuntu. "
sudo apt install dirmngr ca-certificates software-properties-common apt-transport-https curl -y

echo "3 Adding Virtual box GPG Key..."
curl -fSsL https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --dearmor | sudo tee /usr/share/keyrings/virtualbox.gpg > /dev/null

echo "4 Adding the VirtualBox repository to your system's apt sources list \
 so that you can install and update VirtualBox packages"
echo "deb [arch=$( dpkg --print-architecture ) signed-by=/usr/share/keyrings/virtualbox.gpg] http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox-7.list

echo "4.1 Updating the package lists in VB installing..."
sudo apt update

echo "5 If vboxdrv.sh: failed. Then the logs in /var/log/vbox-setup.log will require the installation of gcc"
sudo apt install gcc-12 -y

echo "6 Installing VirtualBox 7.0 and the Linux kernel headers corresponding to your currently running kernel...."
sudo apt install virtualbox-7.0 linux-headers-$(uname -r) -y

echo "Installing build-essential is a meta-package in Ubuntu and other Debian-based distributions. \
It includes a collection of essential packages that are required for building software from source code."
sudo apt install build-essential

echo "Checking the installation status and available versions of the virtualbox-7.0 package on your system."
sudo apt-cache policy virtualbox-7.0

echo "Checking the status of VB. If you want to run VB at the start of the system run: \
sudo systemctl enable vboxdrv --now"
sudo systemctl status vboxdrv

# Verify installations
echo "Verifying installations..."
virtualbox --help 

echo "Installation completed successfully."