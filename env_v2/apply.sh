#!/bin/bash
source inputs/apply.conf

# Check if 'new_env' variable is empty
if [[ -z $new_env ]]; then
  echo "new_env is not set in apply.conf file."
  exit 1
fi

# Check if 'aws_region_name' variable is empty
if [[ -z $aws_region_name ]]; then
  echo "aws_region_name is not set in apply.cong file."
  exit 1
fi

cd $new_env/$aws_region_name

echo "applying iam_role module"
sleep 5
cd iam_role
terragrunt apply --auto-approve --terragrunt-non-interactive
if [ $? -eq 0 ]; then
  echo "Terragrunt apply was successful."
else
  echo "Terragrunt apply failed at iam provisioning"
  exit 1
fi
cd ..


echo "applying vpc module"
sleep 5
cd vpc
terragrunt apply --auto-approve
if [ $? -eq 0 ]; then
  echo "Terragrunt apply was successful."
else
  echo "Terragrunt apply failed at vpc provisioning"
  exit 1
fi

echo "getting subnet ids for istio-ingress"
sleep 5
array_of_subnet_ids=$(terragrunt output --json | jq '.subnets_worker_layer.value')
comma_seperated_subnet_strings="${array_of_subnet_ids:1:-1}"
trimmed_subnet_ids=$(awk '{$1=$1};1' <<< $comma_seperated_subnet_strings)
comma_seperated_subnet_ids=$(echo "$trimmed_subnet_ids" | tr -d '"')
echo comma_seperated_subnet_ids=$comma_seperated_subnet_ids > temp.txt
sed -i 's/ //g' "temp.txt"
cat temp.txt >> ../../../inputs/apply.conf
rm temp.txt
cd ..


echo "applying eks_controlplane module"
sleep 5
cd eks/eks_controlplane
terragrunt apply --auto-approve
if [ $? -eq 0 ]; then
  echo "Terragrunt apply was successful."
else
  echo "Terragrunt apply failed at eks_controlplane provisioning"
  exit 1
fi
cd ../..

echo "applying eks_worker module"
sleep 5
cd eks
dirs=$(find . -type d -name 'eks_worker_*')
for dir in $dirs; do
if [ -d "$dir" ]; then
    cd "$dir"
    terragrunt apply --auto-approve
    if [ $? -eq 0 ]; then
      echo "Terragrunt apply was successful."
    else
      echo "Terragrunt apply failed at eks_worker provisioning"
      exit 1
    fi
    cd ..
fi
done
cd ..

echo "setting kube context to connect cluster"
sleep 5
aws eks update-kubeconfig --region $aws_region_name --name $new_env-aws-eks-$aws_region_name

echo "applying service_account module"
sleep 5
cd service_account
terragrunt apply --auto-approve
if [ $? -eq 0 ]; then
  echo "Terragrunt apply was successful."
else
  echo "Terragrunt apply failed at service_account provisioning"
  exit 1
fi
cd ..
sleep 20
isNodeReady=$(kubectl get nodes | grep "NotReady")
while [ "$isNodeReady" ] 
do
sleep 20
isNodeReady=$(kubectl get nodes | grep "NotReady")
echo "waiting for worker nodes to be Ready"
done
sleep 120

echo "applying argocd module"
sleep 5
cd argocd
find . -type f -exec sed -i 's/<aws-region>/'"$aws_region_name"'/g' {} +
terragrunt apply --auto-approve
if [ $? -eq 0 ]; then
  echo "Terragrunt apply was successful."
else
  echo "Terragrunt apply failed at argocd provisioning"
  exit 1
fi
cd ..

echo "creating foudational layers manifest in git"
sleep 5
source ../../setup/foundational_layers.sh

echo "connectig git repos to argocd"
sleep 5
source ../../setup/connect.sh

echo "applying argoapps module"
sleep 5
cd argoapps
terragrunt apply --auto-approve
if [ $? -eq 0 ]; then
  echo "Terragrunt apply was successful."
else
  echo "Terragrunt apply failed at argoapps provisioning"
  exit 1
fi
cd ..

echo "applying private_dns_zone module"
sleep 5
cd private_dns_zone
terragrunt apply --auto-approve
if [ $? -eq 0 ]; then
  echo "Terragrunt apply was successful."
else
  echo "Terragrunt apply failed at private_dns_zone provisioning"
  exit 1
fi
cd ..


