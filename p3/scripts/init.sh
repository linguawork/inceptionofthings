#!/bin/bash

GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

#install git (previously installed in the script before part1 and 2)
#sudo apt install git

#creating cluster
#areggieS — имя кластера.
#--agents 2 — количество воркеров (можно оставить 1 или убрать вовсе).
#kubectl get nodes (command to check)
sudo k3d cluster create areggieS


# init wil-app
# подключение конфиг файла
#ArgoCD сам подтянет проект из Git и задеплоит
sudo kubectl apply -f ../confs/deploy.yaml



#Warning port-forward
#Эта команда пробрасывает порт:
#kubectl port-forward — перенаправляет порты с кластера Kubernetes на локальный компьютер.
#svc/svc-wil — сервис в Kubernetes, который нужно пробросить.
#-n dev — пробрасывает сервис, который находится в пространстве имён dev.
#8888:8080 — локальный порт 8888 будет перенаправлен на порт 8080 внутри Kubernetes.
echo -e "${GREEN}PORT-FORWARD : sudo kubectl port-forward svc/svc-wil -n dev 8888:8080${RESET}"
