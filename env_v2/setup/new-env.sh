source ../inputs/apply.conf
echo "Creating new environment folder"
echo "#########################"
echo ""
cd ..

# Check if 'new_env' variable is empty
if [[ -z $new_env ]]; then
  echo "new_env is not set in apply.conf file."
  exit 1
fi

# Check if 'aws_region_name' variable is empty
if [[ -z $aws_region_name ]]; then
  echo "aws_region_name is not set in apply.conf file."
  exit 1
fi

mkdir $new_env
cp -r new-env/* $new_env
cd $new_env
mv region-name $aws_region_name
echo ""

echo "#########################"
echo "*"
echo "*"
echo "*"
echo "*"
echo "*"
echo "*******please make sure you have made following changes**********"
echo "*"
echo "*******"
echo "*"
echo "*. Placeholder Chages in $new_env/terragrunt.hcl file"


sed "s|<new-env>|$new_env|" ./terragrunt.hcl > temp_terragrunt.hcl && mv temp_terragrunt.hcl terragrunt.hcl
sed "s|<region-name>|$aws_region_name|" ./terragrunt.hcl > temp_terragrunt.hcl && mv temp_terragrunt.hcl terragrunt.hcl

# Check if 'public_cluster' variable is empty
if [[ -z $is_public_cluster ]]; then
  echo "public_cluster is not set in apply.conf file."
  exit 1
else
  awk -v public_cluster="$is_public_cluster" '/public_cluster[[:blank:]]*=/{gsub(/".*"/, "\"" public_cluster "\"")} 1' ./terragrunt.hcl > temp_terragrunt.hcl && mv temp_terragrunt.hcl terragrunt.hcl
fi

# Check if 'create_app_new_bucket' variable is empty
if [[ -z $create_app_new_bucket ]]; then
  echo "create_app_env_bucket is not set in apply.conf file."
  exit 1
else
  awk -v create_app_env_bucket="$create_app_new_bucket" '/create_app_env_bucket[[:blank:]]*=/{gsub(/".*"/, "\"" create_app_env_bucket "\"")} 1' ./terragrunt.hcl > temp_terragrunt.hcl && mv temp_terragrunt.hcl terragrunt.hcl
fi

# Check if 'existing_vpc_id' variable is empty
if [[ -z $existing_vpc_id ]]; then
  echo "existing_vpc_id is not set in apply.conf file."
else
  awk -v existing_vpc_id="$existing_vpc_id" '/existing_vpc_id[[:blank:]]*=/{gsub(/".*"/, "\"" existing_vpc_id "\"")} 1' ./terragrunt.hcl > temp_terragrunt.hcl && mv temp_terragrunt.hcl terragrunt.hcl
fi

# Check if 'existing_igw_id' variable is empty
if [[ -z $existing_igw_id ]]; then
  echo "existing_igw_id is not set in apply.conf file."
else
  awk -v existing_igw_id="$existing_igw_id" '/existing_igw_id[[:blank:]]*=/{gsub(/".*"/, "\"" existing_igw_id "\"")} 1' ./terragrunt.hcl > temp_terragrunt.hcl && mv temp_terragrunt.hcl terragrunt.hcl
fi

# Check if 'existing_igw_id' variable is empty
if [[ -z $default_vpc ]]; then
  echo "default_vpc is not set in apply.conf file."
else
  awk -v default_vpc="$default_vpc" '/default_vpc[[:blank:]]*=/{gsub(/".*"/, "\"" default_vpc "\"")} 1' ./terragrunt.hcl > temp_terragrunt.hcl && mv temp_terragrunt.hcl terragrunt.hcl
fi

# Check if 'vpc_cidr_block' variable is empty
if [[ -z $vpc_cidr_block ]]; then
  echo "vpc_cidr_block is not set in apply.conf file."
  exit 1
else
  awk -v vpc_cidr_block="$vpc_cidr_block" '/vpc_cidr_block[[:blank:]]*=/{gsub(/".*"/, "\"" vpc_cidr_block "\"")} 1' ./terragrunt.hcl > temp_terragrunt.hcl && mv temp_terragrunt.hcl terragrunt.hcl
fi

# Check if 'create_vpc' variable is empty
if [[ -z $create_vpc ]]; then
  echo "create_vpc is not set in apply.conf file."
  exit 1
else
  awk -v create_vpc="$create_vpc" '/create_vpc[[:blank:]]*=/{gsub(/".*"/, "\"" create_vpc "\"")} 1' ./terragrunt.hcl > temp_terragrunt.hcl && mv temp_terragrunt.hcl terragrunt.hcl
fi

# Check if 'create_igw' variable is empty
if [[ -z $create_igw ]]; then
  echo "create_igw is not set in apply.conf file."
  exit 1
else
  awk -v create_igw="$create_igw" '/create_igw[[:blank:]]*=/{gsub(/".*"/, "\"" create_igw "\"")} 1' ./terragrunt.hcl > temp_terragrunt.hcl && mv temp_terragrunt.hcl terragrunt.hcl
fi


if [[ -z $cluster_AZ ]]; then
  echo "cluster_AZ is not set in apply.conf file."
  exit 1
else
  awk -v cluster_AZ="$cluster_AZ" '/cluster_AZ[[:blank:]]*=/{gsub(/\[.*\]/, cluster_AZ)} 1' ./terragrunt.hcl > temp_terragrunt.hcl && mv temp_terragrunt.hcl ./terragrunt.hcl
fi

if [[ -z $cluster_EIP ]]; then
  echo "cluster_EIP is not set in apply.conf file."
else
  awk -v cluster_EIP="$cluster_EIP" '/cluster_EIP[[:blank:]]*=/{gsub(/\[.*\]/, cluster_EIP)} 1' ./terragrunt.hcl > temp_terragrunt.hcl && mv temp_terragrunt.hcl terragrunt.hcl
fi

if [[ -z $worker_AZ ]]; then
  echo "cluster_AZ is not set in apply.conf file."
  exit 1
else
  awk -v worker_AZ="$worker_AZ" '/worker_AZ[[:blank:]]*=/{gsub(/\[.*\]/, worker_AZ)} 1' ./terragrunt.hcl > temp_terragrunt.hcl && mv temp_terragrunt.hcl terragrunt.hcl
fi

if [[ -z $worker_EIP ]]; then
  echo "worker_EIP is not set in apply.conf file."

else
  awk -v worker_EIP="$worker_EIP" '/worker_EIP[[:blank:]]*=/{gsub(/\[.*\]/, worker_EIP)} 1' ./terragrunt.hcl > temp_terragrunt.hcl && mv temp_terragrunt.hcl terragrunt.hcl
fi

if [[ -z $public_nat_cidr ]]; then
  echo "public_nat_cidr is not set in apply.conf file."
  exit 1
else
  awk -v public_nat_cidr="$public_nat_cidr" '/public_nat_cidr[[:blank:]]*=/{gsub(/\[.*\]/, public_nat_cidr)} 1' ./terragrunt.hcl > temp_terragrunt.hcl && mv temp_terragrunt.hcl terragrunt.hcl
fi

if [[ -z $cluster_cidr ]]; then
  echo "cluster_cidr is not set in apply.conf file."
  exit 1
else
  awk -v cluster_cidr="$cluster_cidr" '/cluster_cidr[[:blank:]]*=/{gsub(/\[.*\]/, cluster_cidr)} 1' ./terragrunt.hcl > temp_terragrunt.hcl && mv temp_terragrunt.hcl terragrunt.hcl
fi

if [[ -z $workernode_cidr ]]; then
  echo "workernode_cidr is not set in apply.conf file."
  exit 1
else
  awk -v workernode_cidr="$workernode_cidr" '/workernode_cidr[[:blank:]]*=/{gsub(/\[.*\]/, workernode_cidr)} 1' ./terragrunt.hcl > temp_terragrunt.hcl && mv temp_terragrunt.hcl terragrunt.hcl
fi 

if [[ -z $key_pair_name ]]; then
  echo "keyname is not set in apply.conf file."
  exit 1
else
  # awk -v keyname="$keyname" '/keyname[[:blank:]]*=/{gsub(/".*"/, "\"" keyname "\"")} 1' ./terragrunt.hcl > temp_terragrunt.hcl && mv temp_terragrunt.hcl terragrunt.hcl
  sed "s|<key-pair-name>|$key_pair_name|" ./terragrunt.hcl > temp_terragrunt.hcl && mv temp_terragrunt.hcl terragrunt.hcl
fi 

if [[ -z $istio_apply_module ]]; then
  echo "istio_apply_module is not set in apply.conf file."
  exit 1
else
  awk -v istio_apply_module="$istio_apply_module" '/istio_apply_module[[:blank:]]*=/{gsub(/".*"/, "\"" istio_apply_module "\"")} 1' ./terragrunt.hcl > temp_terragrunt.hcl && mv temp_terragrunt.hcl terragrunt.hcl
fi 

if [[ -z $ami_id ]]; then
  echo "ami_id is not set in apply.conf file."
  exit 1
else
  awk -v ami_id="$ami_id" '/ami_id[[:blank:]]*=/{gsub(/".*"/, "\"" ami_id "\"")} 1' ./terragrunt.hcl > temp_terragrunt.hcl && mv temp_terragrunt.hcl terragrunt.hcl
fi 

if [[ -z $secrets_manager_name ]]; then
  echo "secrets_manager_name is not set in apply.conf file."
  exit 1
else
  # awk -v secrets_manager_name="$secrets_manager_name" '/name[[:blank:]]*=/{gsub(/".*"/, "\"" secrets_manager_name "\"")} 1' ./terragrunt.hcl > temp_terragrunt.hcl && mv temp_terragrunt.hcl terragrunt.hcl
  sed "s|<secrets-store-name>|$secrets_manager_name|" ./terragrunt.hcl > temp_terragrunt.hcl && mv temp_terragrunt.hcl terragrunt.hcl
fi 

echo "#########################"
echo "pushig $new_env files to git"
git config --global user.name "iac-setup"
git config --global user.email iac-setup
exit 1
git add ../$new_env
git commit -m "adding $new_env"
git push

echo "*"
echo "*******"
echo "*"
