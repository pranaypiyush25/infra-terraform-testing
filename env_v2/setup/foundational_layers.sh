source ../../inputs/apply.conf
echo "creating new working directory for foundational_layers"
mkdir foundational_layers_working
cd foundational_layers_working
echo "cloning foundational_layers_values repo"

if [[ -z $foundational_layers_values_repo_owner ]]; then
  echo "foundational_layers_values_repo_owner is not set in apply.conf file."
  exit 1
else
  git clone -b new-env git@github.com:$foundational_layers_values_repo_owner/foundational-layers-helm-values.git
fi

cd foundational-layers-helm-values
echo "creating $new_env branch from new-env branch"
git branch $new_env
git checkout $new_env


echo "###########################"
echo ""
echo "recursively updating placeholder <new-env>"
find . -type f -exec sed -i 's/<new-env>/'"$new_env"'/g' {} +
echo ""



echo "###########################"
echo ""
echo "recursively updating placeholder <region-name>"
find . -type f -exec sed -i 's/<region-name>/'"$aws_region_name"'/g' {} +
echo ""

echo "###########################"
echo ""
echo "recursively updating placeholder <aws-account-number>"
if [[ -z $$aws_account_id ]]; then
  echo "$aws_account_id is not set in apply.conf file."
  exit 1
else
  find . -type f -exec sed -i 's/<aws-account-number>/'"$aws_account_id"'/g' {} +
fi
echo ""

echo "###########################"
echo ""
echo "recursively updating placeholder <public_nat_subnet_ids>"
if [[ -z $$comma_seperated_subnet_ids ]]; then
  echo "comma_seperated_subnet_ids is not set in apply.conf file."
  exit 1
else
  find . -type f -exec sed -i 's/<public_nat_subnet_ids>/'"$comma_seperated_subnet_ids"'/g' {} +
fi
echo ""

echo "###########################"
echo ""
echo "recursively updating placeholder <aws certificate arn>"
if [[ -z $$aws_certificate_arn ]]; then
  echo "aws_certificate_arn is not set in apply.conf file."
  exit 1
else
  find . -type f -exec sed -i 's/<aws certificate arn>/'"$aws_certificate_arn"'/g' {} +
fi
echo ""

echo "###########################"
echo ""
echo "pushing new branch to git"
git config --global user.name "iac-setup"
git config --global user.email iac-setup
git add '.'
git commit -m "adding $new_env"
git push origin $new_env

cd ../../

rm -rf foundational_layers_working


