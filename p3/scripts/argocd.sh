#!/bin/bash

GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

#creating cluster
#areggieS — имя кластера.
#--agents 2 — количество воркеров (можно оставить 1 или убрать вовсе).
#kubectl get nodes (command to check)
sudo k3d cluster create areggieS

# https://kubernetes.io/docs/tasks/administer-cluster/namespaces/
# creating namespaces: argocd and dev
sudo kubectl create namespace argocd && sudo kubectl create namespace dev

# https://argo-cd.readthedocs.io/en/stable/
#Argo CD рекомендуется ставить в namespace argocd:
#kubectl get pods -n argocd (command to check)
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


# adding entry to  etc/host 
#Открывай в браузере: https://localhost:8080
HOST_ENTRY="127.0.0.1 argocd.mydomain.com"
HOSTS_FILE="/etc/hosts"

if grep -q "$HOST_ENTRY" "$HOSTS_FILE"; then
    echo "exist $HOSTS_FILE"
else
    echo "adding $HOSTS_FILE"
    echo "$HOST_ENTRY" | sudo tee -a "$HOSTS_FILE"
fi

# waitpod
sudo kubectl wait --for=condition=ready --timeout=600s pod --all -n argocd

# password to argocd (user: admin)
#Логин по умолчанию:
echo -n "${GREEN}ARGOCD PASSWORD : "
  sudo kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode
echo "${RESET}"


#Настроить Argo CD для CI/CD
#Доступ к ArgoCD UI:
#Forward порт:
#argocd localhost:8085 or argocd.mydomain.com:8085
sudo kubectl port-forward svc/argocd-server -n argocd 8085:443 > /dev/null 2>&1 &
