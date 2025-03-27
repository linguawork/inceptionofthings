#!/bin/bash

# Set the colors for displaying information in the terminal
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

# Creating an environment variable for installing the master node
# https://docs.k3s.io/installation/configuration#configuration-file


#FLAGS: https://docs.k3s.io/cli/server (flags for server)
#FLAGS: https://docs.k3s.io/cli/agent (flags for agent or worker)
# --write-kubeconfig-mode=644	
# Настраивает права доступа к kubeconfig-файлу (по умолчанию он доступен только root, а с этим параметром доступен всем пользователям для чтения).
# Это полезно для того, чтобы ты мог подключаться к кластеру под обычным пользователем без лишних прав.

#--tls-san serverS	
# Добавляет дополнительное имя (Subject Alternative Name) к TLS сертификатам. Здесь это hostname serverS. Это нужно для того, чтобы можно было обращаться к серверу по имени serverS, а не только по IP. Особенно полезно, если у тебя несколько IP/имён.

#--node-ip=192.168.56.110	
# Явно указывает IP-адрес ноды. Это важно, если у машины несколько сетевых интерфейсов, и ты хочешь использовать конкретный IP для связи. В твоём случае — это приватный IP машины в сети Vagrant.

# --bind-address=192.168.56.110	
# Указывает IP-адрес, на котором K3s будет слушать входящие соединения API-сервера. Это тот же IP, что и выше — 192.168.56.110.

# --advertise-address=192.168.56.110	
# Это IP-адрес, который мастер-нод будет «рекламировать» другим нодам кластера (worker-нодам). То есть другие ноды узнают, как подключиться к мастеру.


#-e:
# Enable interpretation of backslash escapes — позволяет интерпретировать спецсимволы, такие как:
#\n — новая строка.
#\t — табуляция.
#\e или \033 — escape-последовательности для цветов.
#В данном случае переменные ${GREEN} и ${RESET} обычно содержат цветовые escape-последовательности ANSI для раскрашивания текста в терминале.
#Без -e, эти escape-последовательности отображались бы буквально.

if export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --tls-san serverS --node-ip 192.168.56.110 --bind-address=192.168.56.110 --advertise-address=192.168.56.110 "; then
    echo -e "${GREEN}export INSTALL_K3S_EXEC SUCCEEDED${RESET}"
else
    echo -e "${RED}export INSTALL_K3S_EXEC FAILED${RESET}"
fi

# Install master node
# https://docs.k3s.io/quick-start

#-s: убрать лишний вывод.
#-f: чтобы скрипт завершился с ошибкой при проблемах загрузки.
#-L: следовать за редиректами (например, если сайт перенаправляет на другую страницу).

if curl -sfL https://get.k3s.io | sh -; then
    echo -e "${GREEN}K3s MASTER installation SUCCEEDED${RESET}"
else
    echo -e "${RED}K3s MASTER installation FAILED${RESET}"
fi

# To understand the K3s architecture:
# https://docs.k3s.io/architecture
# Copying the Vagrant token to the mounted shared synced folder, which will be necessary to install the worker
# https://docs.k3s.io/quick-start

#папка проекта на хосте с таким же содержимым как на VM (cd to /vagrant)
if sudo cat /var/lib/rancher/k3s/server/token > /vagrant/token.env; then
    echo -e "${GREEN}TOKEN SUCCESSFULLY SAVED${RESET}"
else
    echo -e "${RED}TOKEN SAVING FAILED${RESET}"
fi

# The command "sudo ip link" add eth1 type dummy creates a virtual network interface named eth1
# The command "sudo ip addr" add 192.168.56.110/24 dev eth1 assigns the IP address 192.168.56.110 with a subnet mask of /24
# The final part, sudo ip link set eth1 up, activates the eth1 interface.

if sudo ip link add eth1 type dummy && sudo ip addr add 192.168.56.110/24 dev eth1 && sudo ip link set eth1 up; then
    echo -e "${GREEN}add eth1 SUCCEESSFULLY${RESET}"
else
    echo -e "${RED}add eth1 FAILED${RESET}"
fi


