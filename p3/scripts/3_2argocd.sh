#!/bin/bash

GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"
#This script is run after the installing all the neccessary soft: Docker, K3d ...
#Here we make cluster, apply argocd crds, create namespaces, apply ArgoCD manifest with resources: Deployment, Service, ConfigMap и т. д.
# add entry to etc/host, wait pods to be raised, generate secret path and user (admin)



#creating cluster
#areggieS — имя кластера.
#--agents 2 — количество воркеров (можно оставить 1 или убрать вовсе).
#kubectl get nodes (command to check)
sudo k3d cluster create areggieS





sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/crds.yaml





# https://kubernetes.io/docs/tasks/administer-cluster/namespaces/
# creating namespaces: argocd and dev
sudo kubectl create namespace argocd && sudo kubectl create namespace dev





# https://argo-cd.readthedocs.io/en/stable/
#Argo CD рекомендуется ставить в namespace argocd:
    #kubectl get pods -n argocd (command to check)
#команда для развёртывания Argo CD в Kubernetes.
#Скачивает манифест install.yaml с GitHub-репозитория Argo CD.
#Применяет этот манифест в Kubernetes в пространстве имён argocd.
#Разворачивает все необходимые ресурсы Argo CD (Deployment, Service, ConfigMap и т. д.).
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
#-n argocd (--namespace argocd)
#Указывает, что манифест будет применён в пространстве имён argocd.
#Если пространство имён не существует, команда может не сработать (нужно создать его заранее: kubectl create namespace argocd).
#-f <file> (--filename <file>)
#Определяет путь к YAML-файлу манифеста Kubernetes.
#В данном случае, kubectl apply скачивает YAML-файл напрямую из GitHub и применяет его.
    #После установки можно проверить статус командами:
      #kubectl get pods -n argocd
      #или
      #kubectl get svc -n argocd

#После установки Argo CD UI можно будет открыть через порт-форвардинг:
    #kubectl port-forward svc/argocd-server -n argocd 8080:443
    #И затем зайти в браузере: https://localhost:8080







#adding entry to  etc/host 
#Открывай в браузере: https://localhost:8080 или по argocd.mydomain.com:8080
HOST_ENTRY="127.0.0.1 argocd.mydomain.com"
HOSTS_FILE="/etc/hosts"

#-q (--quiet) — тихий режим, при котором grep не выводит результат в консоль.
# Он только проверяет, есть ли совпадение, и возвращает код выхода (0 = найдено, 1 = не найдено).
if grep -q "$HOST_ENTRY" "$HOSTS_FILE"; then
    echo "exist $HOSTS_FILE"
else
    echo "adding $HOSTS_FILE"
    echo "$HOST_ENTRY" | sudo tee -a "$HOSTS_FILE"
fi
#-a (--append) — добавляет (append) текст в конец файла вместо перезаписи.
#Без -a, tee перезаписал бы весь файл, удалив существующие строки.

#Если ты хочешь доступ из других машин в сети, этого недостаточно.
#В таком случае тебе нужен полноценный DNS-запись + настройка ingress-контроллера в Kubernetes.




# waitpod
#Ожидает, пока все поды в пространстве имён argocd не будут в состоянии Ready.
#но если они поднимутся раньше, ожидание сразу завершится.
#Время ожидания ограничено 600 секунд (10 минутами).
#Если все поды не станут готовы за это время, команда завершится с ошибкой.

sudo kubectl wait --for=condition=ready --timeout=600s pod --all -n argocd
#в случае готовности
#pod/my-pod-1 condition met
#pod/my-pod-2 condition met
#...
#error: timed out waiting for the condition
#RhEENiNcxQHMymAk



#password to argocd (user: admin)
#Этот скрипт используется для получения пароля администратора Argo CD, используя секрет, который был автоматически создан при установке Argo CD в Kubernetes.
echo -n "${GREEN}ARGOCD PASSWORD : "
  sudo kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode
echo "${RESET}"
echo -n "${GREEN}ARGOCD PASSWORD : "
#-n — предотвращает добавление новой строки в конце (по умолчанию echo добавляет её).
#kubectl get secret — команда для получения секрета в Kubernetes.
#argocd-initial-admin-secret — секрет, содержащий начальный пароль для пользователя admin Argo CD.
#-n argocd — указывает пространство имён argocd, где размещён секрет.
#-o jsonpath="{.data.password}" — извлекает значение поля password из секрета в формате JSON (секрет хранится в base64).
#| base64 --decode:  Декодирует значение пароля, которое хранится в формате base64 в Kubernetes.
#После декодирования будет отображён настоящий пароль для пользователя admin.
#Примерный вывод: ARGOCD PASSWORD : your-decoded-password






#argocd localhost:8080 or argocd.mydomain.com:8080

# Эта команда перенаправляет локальный порт 8080 (на компьютере, откуда выполняется команда)  
# на порт 443 ArgoCD сервера (UI ArgoCD) внутри кластера Kubernetes.  
# Это позволяет открыть веб-интерфейс ArgoCD в браузере по адресу https://localhost:8080  
# и работать с ним, как если бы он был запущен локально.


sudo kubectl port-forward svc/argocd-server -n argocd 8080:443 > /dev/null 2>&1 &
#номер порта можно менять (на любой нужный)
#kubectl port-forward — используется для перенаправления портов с локальной машины на сервис в Kubernetes.
#svc/argocd-server — указывает на сервис argocd-server в Kubernetes, который обычно управляет доступом к UI Argo CD.
#-n argocd — указывает пространство имён argocd, где находится сервис argocd-server.
#8080:443 — локальный порт 8080 будет перенаправлен на порт 443 сервиса (порт HTTPS).
#> /dev/null 2>&1
#> /dev/null — перенаправляет стандартный вывод (stdout) в /dev/null, то есть скрывает его (не будет выводиться информация о процессе).
#2>&1 — перенаправляет ошибки (stderr) в тот же поток, что и стандартный вывод (в данном случае в /dev/null), так что ошибки также не будут выводиться
#при этом вывод и ошибки перенаправляются в фоновый режим.
#& — запускает команду в фоновом режиме. Это позволяет командной строке сразу вернуть контроль, не дожидаясь завершения выполнения команды.


#Вы можете получить доступ к Argo CD UI, открыв браузер по адресу http://localhost:8080 милм по argocd.mydomain.com:8080
#Вывод и ошибки команды скрыты (они не будут отображаться в терминале).
#Команда выполняется в фоновом режиме, позволяя вам продолжать работать в терминале, не дожидаясь завершения перенаправления.