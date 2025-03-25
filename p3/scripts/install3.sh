#!/bin/bash

#The script to install dependencies, Docker, K3D, Kubectl, optionally helm

#https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit
# Set the colors for displaying information in the terminal
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
RESET="\033[0m"



# Greet user 
#\e или \033 — escape-последовательности для цветов.
echo -e "${YELLOW}Hi there, areggie decided to run all the installations of software \
 via bash script for part 3 of IoT. \
 The script to install dependencies, Docker, K3D, Kubectl, optionally helm ${RESET}"


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
    #-s: убрать лишний вывод.
    #-f: чтобы скрипт завершился с ошибкой при проблемах загрузки.
    #-L: следовать за редиректами (например, если сайт перенаправляет на другую страницу).
    #-S: даже если используется флаг -s (который отключает вывод в стандартный поток). Вместо того, чтобы молчать при ошибках, -S заставляет curl выводить сообщения об ошибках, если что-то пойдет не так, например, проблемы с подключением или загрузкой.
    # --dearmor в команде gpg используется для преобразования ключа из ASCII-формата (Armored) в бинарный формат.
    # -o (или --output) указывает, куда сохранить результат.
        #Debian-based системы (включая Ubuntu) теперь требуют, чтобы ключи GPG для репозиториев хранились в /usr/share/keyrings/ в бинарном формате.
        #Ранее ключи добавлялись через apt-key, но этот метод устарел и больше не рекомендуется.


    # Команда вводит строку с описанием репо
    #deb [...] URL DISTRIBUTION COMPONENT — формат строки для sources.list
    #deb — означает, что добавляется бинарное хранилище пакетов (в отличие от deb-src для исходников).
    #[arch=$(dpkg --print-architecture)] — указывает архитектуру системы (amd64, arm64, i386 и т. д.).
    #signed-by=/usr/share/keyrings/docker-archive-keyring.gpg — указывает, что пакеты должны проверяться этим ключом (ранее импортированным командой gpg --dearmor).
    #$(lsb_release -cs) — динамически подставляет кодовое имя дистрибутива (например, jammy для Ubuntu 22.04).
    #stable — ветка репозитория, содержащая стабильные версии Docker.

    # tee /etc/apt/sources.list.d/docker.list
    # tee — утилита, которая записывает входные данные (из stdin) одновременно в файл и stdout (терминал).
    # > /dev/null
    #> — перенаправляет стандартный вывод (stdout).
    #/dev/null — специальное устройство, которое "глотает" входные данные, т.е. их не видно в терминале.
    #/etc/apt/sources.list.d/docker.list — файл, в который записываются данные.

   echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
   sudo apt update && \
   sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
   sudo usermod -aG docker $USER; then #добавляет текущего пользователя в группу docker
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

# curl -LO — скачивает файл, сохраняя его под тем же именем.
#-L (follow redirects) — следует за редиректами.
#-O (output to file) — сохраняет файл с оригинальным именем.
curl -LO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" #получает последнюю стабильную версию Kubernetes.
curl -LO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

#Добавлена проверка подлинности kubectl перед установкой.
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check #of ok, will print: kubectl: OK



#if [ $? -eq 0 ]; then
#$? — это код возврата последней выполненной команды.
#-eq 0 проверяет, что код равен 0 (что означает "успешное выполнение").
#Если код возврата 0, выполняется блок then.
#То есть, если curl -LO ... завершился без ошибок, то установка kubectl продолжается.
if [ $? -eq 0 ]; then
#делает файл kubectl исполняемым.
    chmod +x kubectl && \ 
    sudo mv kubectl /usr/local/bin/ && \
    echo -e "${GREEN}Installing Kubectl was SUCCESSFUL${RESET}"
else
    echo -e "${RED}SHA256 check failed! Kubectl installation aborted.${RESET}"
    exit 1 #Ошибка в SHA256 останавливает скрипт (exit 1), предотвращая установку поврежденного или подмененного бинарника.
fi
#kubectl version --client (чтобы проверить установку)




#(опционально для бонуса) Установка helm
#curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo -e "${YELLOW}Все нужные компоненты установлены! Перезайди в терминал или используй 'newgrp docker' для активации docker-группы.${RESET}"

echo -e "${GREEN}INSTALLATION BLOCK OF SOFTWARE COMPLETED SUCCESSFULLY.${RESET}"
