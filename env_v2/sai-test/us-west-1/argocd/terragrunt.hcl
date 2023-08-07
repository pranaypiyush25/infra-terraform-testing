terraform {
  source = "/home/ec2-user/infra-terraform//modules_v2/kubernetes"
}

include {
  path = find_in_parent_folders()
}
dependency "service_account" {
  config_path = "../service_account"
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

inputs = {
  env                       = local.account_vars.locals.env
  region                    = local.account_vars.locals.region
  cluster_name              = local.account_vars.locals.cluster_name
  version_argocd            = local.account_vars.locals.argocd.version_argocd
  app_namespace             = local.account_vars.locals.argocd.app_namespace
  foundationlayer_namespace = local.account_vars.locals.argocd.foundationlayer_namespace
}