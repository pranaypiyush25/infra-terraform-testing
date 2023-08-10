terraform {
  source = "/home/ec2-user/code-sai-test/infra-terraform//modules_v2/argoapps"
}

include {
  path = find_in_parent_folders()
}
dependency "argocd" {
  config_path = "../argocd"
  skip_outputs = "true"
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

inputs = {
  env                = local.account_vars.locals.env
  region             = local.account_vars.locals.region
  cluster_name       = local.account_vars.locals.cluster_name
  istio_apply_module = local.account_vars.locals.argocd.istio_apply_module
  aws_secretsmanager_arn = local.account_vars.locals.argocd.aws_secretsmanager_arn
}