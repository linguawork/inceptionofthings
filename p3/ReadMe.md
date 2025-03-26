В контексте Kubernetes и ArgoCD .yaml-файлы чаще всего называют манифестами.

Scripts:
If the soft and dependences are NOT installed:
run 3_1install.sh first. 


If the soft and dependences are installed:

First run:
3_2argocd.sh – деплой ArgoCD ( основного программного манифеста и пр)

Secondly run the deploy of argo cd:
3_3init.sh – деплой локального манифеста (с путем на гит), проброс портов на локальной машине