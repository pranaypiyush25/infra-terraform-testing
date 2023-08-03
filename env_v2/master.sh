#!/bin/bash
source inputs/apply.conf
currentPath=$(pwd)
cd ../..
echo "cloning terraform modules repo"
if [[ -z $terraform_modules_repo_ssh_clone ]]; then
  echo "terraform_modules_repo_ssh_clone is not set in apply.conf file."
  exit 1
fi
git clone $terraform_modules_repo_ssh_clone
cd $currentPath
echo "#########################"
echo "configure aws credentials"
echo "#########################"
aws configure
echo "#########################"
clear

# Check if 'new_env' variable is empty
if [[ -z $new_env ]]; then
  echo "new_env is not set in apply.conf file."
  exit 1
fi

# Create SSH key for EC2 worker nodes
#############
##################################
# Check if 'key_pair_name' variable is empty
if [[ -z $key_pair_name ]]; then
  echo "key_pair_name is not set in apply.cong file. Please provide all values to process further."
  exit 1
else
  aws ec2 create-key-pair --key-name $key_pair_name --query 'KeyMaterial' --output text > $key_pair_name.pem
  chmod 400 $key_pair_name.pem
fi
##################################
#############



# Allocate Elastic IP addresses
#############
##################################

trimmed_cluster_AZ=$(echo "$cluster_AZ" | tr -d " '")
number_of_values=$(echo "$trimmed_cluster_AZ" | jq length)
cluster_ip_addresses="'["

for ((i=1; i<=$number_of_values; i++)); do
  response=$(aws ec2 allocate-address --tag-specifications "ResourceType=elastic-ip,Tags=[{Key=Name,Value=$new_env-eks-cluster-$i}]")
  if echo "$response" | grep -q "AddressLimitExceeded"; then
    echo "Error: The maximum number of addresses has been reached. Go to the Support Page to increase limit for Elastic IPs"
    exit 1 
  else
    ip_address=$(echo "$response" | jq -r '.PublicIp')
    cluster_ip_addresses+="\"$ip_address\""

    # Add a comma after each IP address except for the last one
    if [ $i -ne $number_of_values ]; then
      cluster_ip_addresses+=","
    fi
  fi
done
cluster_ip_addresses+="]'"
echo "cluster_EIP=$cluster_ip_addresses" >> ./inputs/apply.conf

##################################
##################################
##################################

trimmed_worker_AZ=$(echo "$worker_AZ" | tr -d " '")
number_of_values=$(echo "$trimmed_worker_AZ" | jq length)
worker_ip_addresses="'["

for ((i=1; i<=$number_of_values; i++)); do
  response=$(aws ec2 allocate-address --tag-specifications "ResourceType=elastic-ip,Tags=[{Key=Name,Value=$new_env-eks-worker-$i}]")
  if echo "$response" | grep -q "AddressLimitExceeded"; then
    echo "Error: The maximum number of addresses has been reached."
    exit 1
  else
    ip_address=$(echo "$response" | jq -r '.PublicIp')
    worker_ip_addresses+="\"$ip_address\""

    # Add a comma after each IP address except for the last one
    if [ $i -ne $number_of_values ]; then
      worker_ip_addresses+=","
    fi
  fi
done
worker_ip_addresses+="]'"
echo "worker_EIP=$worker_ip_addresses" >> ./inputs/apply.conf

##################################
#############
echo ""
chmod +x setup/new-env.sh
cd setup
./new-env.sh
cd ..
echo "#########################"

echo ""
chmod +x apply.sh
./apply.sh
cd ..
echo "#########################"


