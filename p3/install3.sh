#!/bin/bash

#The script to install dependencies, Docker, K3D, Kubectl, optionally helm

#https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit
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
# though I have installed gnupg2, we will check again with gnupg2
#В Ubuntu Jellyfish (22.04) при установке gnupg автоматически подтягивается версия 2.x, фактически это синоним
#второй вызов sudo apt install gnupg в скрипте не навредит, он просто убедится, что пакет установлен, и всё.
#Установка зависимостей: curl, wget, ca-certificates уже была в install2.sh
# Но Повторений особо нет, apt сам отфильтрует уже установленные пакеты. Можно смело оставить.
echo -e "${YELLOW}2 Installing required dependencies: curl  ca-certificates gnupg${RESET}"
if sudo apt install -y ca-certificates curl gnupg lsb-release; then
    echo -e "${GREEN}Installation of required dependencies was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Installation of required dependencies FAILED${RESET}"
fi



echo -e "${YELLOW}3 Adding Docker GPG Key, Adding Official Docker Repository, \
 Installing Docker, Adding user to the Docker group${RESET}"
# обычно докер хранит в своей папке sudo mkdir -p /etc/apt/keyrings
# но я решил хранить в своей
# так как папка уже создана в install.sh поэтому опустим: sudo mkdir -p /usr/share/keyrings/ 
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





# Установка K3D
echo -e "${YELLOW}Installing K3D...${RESET}"
if curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash; then
    echo -e "${GREEN}Installing K3D was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Installing K3D FAILED${RESET}"
fi


# Установка kubectl
# В отличие от K3S, K3D не устанавливает kubectl по умолчанию
echo -e "${YELLOW}Installing Kubectl...${RESET}"
if curl -LO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"; then
    chmod +x kubectl && \
    sudo mv kubectl /usr/local/bin/ && \
    echo -e "${GREEN}Installing Kubectl was SUCCESSFUL${RESET}"
else
    echo -e "${RED}Installing Kubectl FAILED${RESET}"
fi




# (опционально) Установка helm
#curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "Все нужные компоненты установлены! Перезайди в терминал или используй 'newgrp docker' для активации docker-группы."


echo -e "${GREEN}INSTALLATION BLOCK OF SOFTWARE COMPLETED SUCCESSFULLY.${RESET}"
