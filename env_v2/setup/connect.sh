source ../../inputs/apply.conf
echo "getting login creds for argocd admin"
ARGO_LB=$(kubectl get service argocd-server -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' -n argocd)
ARGO_ADMIN_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

echo "####################"
echo "logging into argocd using cli to connect foundational helm&git repos"
echo -y | argocd login $ARGO_LB --insecure --username "admin" --password "$ARGO_ADMIN_PASSWORD"

if [[ -z $foundational_helm_charts_repo ]] || [[ -z $git_pat_read_user ]] || [[ -z $git_pat_read ]]; then
  echo "foundational_helm_charts_repo or git_pat_read_user or git_pat_read is not set in apply.conf file."
  exit 1
else 
  argocd repo add $foundational_helm_charts_repo --username $git_pat_read_user --password $git_pat_read --type helm  --name foundational-helm-charts
fi

if [[ -z $foundational_helm_values_repo ]] || [[ -z $git_pat_read_user ]] || [[ -z $git_pat_read ]]; then
  echo "foundational_helm_values_repo or git_pat_read_user or git_pat_read is not set in apply.conf file."
  exit 1
else 
  argocd repo add $foundational_helm_values_repo --username $git_pat_read_user --password $git_pat_read
fi
