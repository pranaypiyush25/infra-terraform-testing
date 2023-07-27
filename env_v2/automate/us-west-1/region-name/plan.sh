#!/bin/bash
exit_selected=false

# Loop until exit is selected
while [ "$exit_selected" = false ]; do
  # Prompt the user to enter a choice
  echo "Choose a module to provision:"
  echo "0. Exit"
  echo "1. iam_role"
  echo "2. vpc"
  echo "3. eks/eks_controlplane"
  echo "4. eks/eks_worker_*"
  echo "5. service_account"
  echo "6. argocd"
  echo "7. argoapps"
  echo "8. private_dns_zone"
  echo "9. mongodbatlas"
  read -p "Enter your choice: " choice

  # Perform actions based on the user's choice
  case $choice in
    0)
      echo "Exit selected"
      exit_selected=true
      ;;
    1)
      cd iam_role
      terragrunt plan
      cd ..
      ;;
    2)
      cd vpc
      terragrunt plan
      cd ..
      ;;
    3)
      cd eks/eks_controlplane
      terragrunt plan
      cd ../..
      ;;
    4)
      cd eks
      dirs=$(find . -type d -name 'eks_worker_*')
      for dir in $dirs; do
      if [ -d "$dir" ]; then
          cd "$dir"
          terragrunt plan
          cd ..
      fi
      done
      cd ..
      ;;
    5)
      cd service_account
      terragrunt plan
      cd ..
      ;;
    6)
      cd argocd
      terragrunt plan
      cd ..
      ;;
    7)
      cd argoapps
      terragrunt plan
      cd ..
      ;;
    8)
      cd private_dns_zone
      terragrunt plan
      cd ..
      ;;
    9)
      cd mongodbatlas
      terragrunt plan
      cd ..
      ;;
    *)
      echo "Invalid choice"
      ;;
  esac
done
