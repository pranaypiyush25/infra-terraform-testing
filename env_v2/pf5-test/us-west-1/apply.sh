#!/bin/bash
exit_selected=false
source ../../inputs.conf
# Loop until exit is selected
while [ "$exit_selected" = false ]; do
  # Prompt the user to enter a choice
  echo "Choose a module to provision:"
  echo "0. Exit"
  echo "1. iam_role"
  echo "2. vpc"
  echo "3. eks/eks_controlplane"
  echo "4. eks/eks_worker_*"
  echo "5. kub-config-update"
  echo "6. service_account"
  echo "7. argocd"
  echo "8. argoapps"
  echo "9. private_dns_zone"
  echo "10. mongodbatlas"
  read -p "Enter your choice: " choice

  # Perform actions based on the user's choice
  case $choice in
    0)
      echo "Exit selected"
      exit_selected=true
      ;;
    1)
      cd iam_role
      terragrunt apply --auto-approve --terragrunt-non-interactive
      cd ..
      ;;
    2)
      cd vpc
      terragrunt apply --auto-approve
      array_of_subnet_ids=$(terragrunt output --json | jq '.subnets_worker_layer.value')
      comma_seperated_subnet_strings="${array_of_subnet_ids:1:-1}"
      trimmed_subnet_ids=$(awk '{$1=$1};1' <<< $comma_seperated_subnet_strings)
      comma_seperated_subnet_ids=$(echo "$trimmed_subnet_ids" | tr -d '"')
      echo comma_seperated_subnet_ids=$comma_seperated_subnet_ids > temp.txt
      sed -i 's/ //g' "temp.txt"
      cat temp.txt >> ../../../inputs.conf
      rm temp.txt
      cd ..
      ;;
    3)
      cd eks/eks_controlplane
      terragrunt apply --auto-approve
      cd ../..
      ;;
    4)
      cd eks
      dirs=$(find . -type d -name 'eks_worker_*')
      for dir in $dirs; do
      if [ -d "$dir" ]; then
          cd "$dir"
          terragrunt apply --auto-approve
          cd ..
      fi
      done
      cd ..
      ;;
    5)
      aws eks update-kubeconfig --region $aws_region_name --name $new_env-aws-eks-$aws_region_name
      ;;
    6)
      cd service_account
      terragrunt apply --auto-approve
      cd ..
      ;;
    7)
      cd argocd
      terragrunt apply --auto-approve
      cd ..
      ;;
    8)
      cd argoapps
      terragrunt apply --auto-approve
      cd ..
      ;;
    9)
      cd private_dns_zone
      terragrunt apply --auto-approve
      cd ..
      ;;
    10)
      cd mongodbatlas
      terragrunt apply --auto-approve
      cd ..
      ;;
    *)
      echo "Invalid choice"
      ;;
  esac
done
