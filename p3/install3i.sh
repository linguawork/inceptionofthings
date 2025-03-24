#!/bin/bash

# The script is slightly improved and modified
# The script to install dependencies, Docker, K3D, Kubectl, optionally Helm


# Set the colors for displaying information in the terminal
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
RESET="\033[0m"

# Greet user 
echo "Hi there, areggie decided to run all the installations of software via bash script for part 3."

# Update package lists
echo -e "${YELLOW}1 Updating and upgrading package lists...${RESET}"
if sudo apt update && sudo apt upgrade -y; then
    echo -e "${GREEN}Update and upgrade was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Update and upgrade FAILED${RESET}"
fi

# Install required dependencies
echo -e "${YELLOW}2 Installing required dependencies: curl ca-certificates gnupg${RESET}"
if sudo apt install -y ca-certificates curl gnupg lsb-release; then
    echo -e "${GREEN}Installation of required dependencies was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Installation of required dependencies FAILED${RESET}"
fi

# Docker GPG Key, Docker Repository, Installing Docker, Adding user to Docker group
echo -e "${YELLOW}3 Adding Docker GPG Key, Adding Official Docker Repository, \
 Installing Docker, Adding user to the Docker group${RESET}"
if curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
   echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
   sudo apt update && \
   sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
   sudo usermod -aG docker $USER; then
    echo -e "${GREEN}Adding Docker's GPG Key was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Adding Docker's GPG Key FAILED${RESET}"
fi

# Installing K3D
echo -e "${YELLOW}Installing K3D...${RESET}"
if curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash; then
    echo -e "${GREEN}Installing K3D was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Installing K3D FAILED${RESET}"
fi

# Installing Kubectl
echo -e "${YELLOW}Installing Kubectl...${RESET}"
if curl -LO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"; then
    chmod +x kubectl && \
    sudo mv kubectl /usr/local/bin/ && \
    echo -e "${GREEN}Installing Kubectl was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Installing Kubectl FAILED${RESET}"
fi

# (Optional) Installing Helm
# Uncomment to enable Helm installation
# echo -e "${YELLOW}Installing Helm...${RESET}"
# if curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash; then
#     echo -e "${GREEN}Installing Helm was SUCCESSFUL${RESET}"
# else
#     echo -e "${RED}Installing Helm FAILED${RESET}"
# fi

echo "All necessary components have been installed! Please restart your terminal or use 'newgrp docker' to activate the docker group."

echo -e "${GREEN}INSTALLATION BLOCK OF SOFTWARE COMPLETED SUCCESSFULLY.${RESET}"
