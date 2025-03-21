#!/bin/bash

#The script to install Vagrant, VB, net-tools, git, openssh, VScodiun

#Before running the script add your user of the VM to sudoers
#enter with root: su
#the command: adduser $USER sudo


# Set the colors for displaying information in the terminal
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"



# Greet user 
echo "Hi there, areggie decided to run all the installations via bash script, 
we will install Vagrant, VB, net-tools, git, codium, openssh etc on Ubuntu JellyFish. "



# Update package lists
echo "1 Updating and upgrading package lists..."
if sudo apt update && sudo apt upgrade -y; then
    echo -e "${GREEN}Update and upgrade was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Update and upgrade FAILED${RESET}"
fi

# Install required dependencies
echo "2 Installing required dependencies: curl, wget, gnupg2"
if sudo sudo apt install -y curl wget gnupg2; then
    echo -e "${GREEN}Installation of curl wget gnupg2 was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Installation of curl wget gnupg2 FAILED${RESET}"
fi

echo "3 Adding HashiCorp's GPG Key..."
if curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg; then
    echo -e "${GREEN}Adding HashiCorp's GPG Key was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Adding HashiCorp's GPG Key FAILED${RESET}"
fi


echo "4 Adding HashiCorp's Official APT Repository..."
if sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list' ; then 
    echo -e "${GREEN}Adding HashiCorp's Official APT Repository was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Adding HashiCorp's Official APT Repository FAILED${RESET}"
fi


echo "4.1 Updating the package lists..."
if sudo apt update ; then
    echo -e "${GREEN}Update was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Update FAILED${RESET}"
fi


echo "5 Installing vagrant...checking the version"
if sudo apt install vagrant -y && sudo vagrant --version; then
    echo -e "${GREEN}Installing vagrant was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Installing vagrant FAILED${RESET}"
fi

#Install VirtualBox
echo "Installing VirtualBox... after Vagrant"

#Update package lists
echo "1 Updating and upgrading package lists..."
if sudo apt update && sudo apt upgrade -y; then
    echo -e "${GREEN}Update and upgrade was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Update and upgrade FAILED${RESET}"
fi


echo "2 Installing several packages on your system using apt, \
which is the package management tool \
used by Debian-based distributions like Ubuntu. "
if sudo apt install dirmngr ca-certificates software-properties-common apt-transport-https curl -y; then
    echo -e "${GREEN}Installing several packages was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Installing several packages FAILED${RESET}"
fi

echo "3 Adding Virtual box GPG Key..."
if curl -fSsL https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --dearmor | sudo tee /usr/share/keyrings/virtualbox.gpg > /dev/null; then
    echo -e "${GREEN}Adding Virtual box GPG Key was successful${RESET}"
else
    echo -e "${RED}Adding Virtual box GPG Key FAILED${RESET}"
fi


echo "4 Adding the VirtualBox repository to your system's apt sources list \
 so that you can install and update VirtualBox packages"
if echo "deb [arch=$( dpkg --print-architecture ) signed-by=/usr/share/keyrings/virtualbox.gpg] http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox-7.list ; then 
    echo -e "${GREEN}Adding the VirtualBox repository to your system's apt sources list was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Adding the VirtualBox repository to your system's apt sources list FAILED${RESET}"
fi


echo "4.1 Updating the package lists in VB installing..."
if sudo apt update ; then
    echo -e "${GREEN}Update was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Update FAILED${RESET}"
fi

echo "5 If vboxdrv.sh: failed. Then the logs in /var/log/vbox-setup.log will require the installation of gcc"
if sudo apt install gcc-12 -y ; then
    echo -e "${GREEN}Installation of gcc-12 was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Installation of gcc-12 FAILED${RESET}"
fi

echo "6 Installing VirtualBox 7.0 and the Linux kernel headers corresponding to your currently running kernel...."
if sudo apt install virtualbox-7.0 linux-headers-$(uname -r) -y ; then
    echo -e "${GREEN}Installing virtualbox-7.0 linux-headers was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Installing virtualbox-7.0 linux-headers FAILED${RESET}"
fi


echo "Installing build-essential is a meta-package in Ubuntu and other Debian-based distributions. \
It includes a collection of essential packages that are required for building software from source code."
if sudo apt install build-essential ; then
    echo -e "${GREEN}Installing build-essential was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Installing build-essential FAILED${RESET}"
fi

echo "Checking the installation status and available versions of the virtualbox-7.0 package on your system."
if sudo apt-cache policy virtualbox-7.0 ; then
    echo -e "${GREEN}Checking the installation status and available versions of the virtualbox-7.0 package was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Checking the installation status and available versions of the virtualbox-7.0 package FAILED${RESET}"
fi

echo "Checking the status of VB. If you want to run VB at the start of the system run: \
sudo systemctl enable vboxdrv --now"
if sudo systemctl status vboxdrv; then
    echo -e "${GREEN}Enabling VB at the start of the system was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Enabling VB at the start of the system FAILED${RESET}"
fi


#Verify installations
echo "Verifying installations..."
if virtualbox --help ; then
    echo -e "${GREEN}Verifying installations of VB was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Verifying installations of VB FAILED${RESET}"
fi


#Installing net-tools for ifconfig
echo "Installing net-tools"
if sudo apt install net-tools ; then
    echo -e "${GREEN}Installing net-tool for ifconfig command was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Installing net-tool for ifconfig command FAILED${RESET}"
fi

#Installing git
echo "Installing git"
if sudo apt install git -y ; then
    echo -e "${GREEN}Installing net-tool for ifconfig command was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Installing net-tool for ifconfig command FAILED${RESET}"
fi

#Updating
echo "Updating the package lists ..."
if sudo apt update ; then
    echo -e "${GREEN}Update was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Update FAILED${RESET}"
fi



# Installing CODIUM
echo "Installing CODIUM..."
if sudo apt install dirmngr software-properties-common apt-transport-https curl -y &&
curl -fSsL https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | sudo gpg --dearmor | sudo tee /usr/share/keyrings/vscodium.gpg > /dev/null &&
echo deb [signed-by=/usr/share/keyrings/vscodium.gpg] https://download.vscodium.com/debs vscodium main | sudo tee /etc/apt/sources.list.d/vscodium.list &&
sudo apt update &&
sudo apt install codium -y ; then
    echo -e "${GREEN}Installation of CODIUM with apt packet manager was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Installation of CODIUM with apt FAILED${RESET}"
fi


#installing OPENSSH
echo "Installing OPENSSH ..."
if sudo apt install openssh-server -y &&
sudo systemctl start sshd &&
sudo systmectl enable sshd ; then
    echo -e "${GREEN}Installing, starting OPENSSH, enabling at system start was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Installing, starting OPENSSH, enabling at system start FAILED${RESET}"
fi

ps aux | grep ssh
sudo ufw status
#uncomment if the ufw is active
#sudo ufw allow 22

echo "Make sure to check:PermitRootLogin yes \ 
and PasswordAuthentication yes, then save and go out of nano"
#The script will not continue to execute the next commands until nano exits.
sudo nano /etc/ssh/sshd_config


echo "Restart OPENSSH with:sudo systemctl restart sshd \
and check the status with: \
sudo systemctl status sshd"

echo "Restart OPENSSH and checking the status..."
if sudo systemctl restart sshd &&
sudo systemctl status sshd; then
    echo -e "${GREEN}URestart OPENSSH and checking the status was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Restart OPENSSH and checking the status FAILED${RESET}"
fi



echo "Installation completed successfully."
