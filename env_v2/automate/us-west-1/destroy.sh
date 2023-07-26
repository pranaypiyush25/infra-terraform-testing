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
      terragrunt destroy
      cd ..
      ;;
    2)
      cd vpc
      terragrunt destroy
      cd ..
      ;;
    3)
      cd eks/eks_controlplane
      terragrunt destroy
      cd ../..
      ;;
    4)
      cd eks
      dirs=$(find . -type d -name 'eks_worker_*')
      for dir in $dirs; do
      if [ -d "$dir" ]; then
          cd "$dir"
          terragrunt destroy
          cd ..
      fi
      done
      cd ..
      ;;
    5)
      cd service_account
      terragrunt destroy
      cd ..
      ;;
    6)
      cd argocd
      terragrunt destroy
      cd ..
      ;;
    7)
      cd argoapps
      terragrunt destroy
      cd ..
      ;;
    8)
      cd private_dns_zone
      terragrunt destroy
      cd ..
      ;;
    9)
      cd mongodbatlas
      terragrunt destroy
      cd ..
      ;;
    *)
      echo "Invalid choice"
      ;;
  esac
done
