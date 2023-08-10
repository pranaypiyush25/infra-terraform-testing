terraform {
  source = "/home/ec2-user/infra-terraform//modules_v2/iam_roles"
}

include {
  path = find_in_parent_folders()
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

inputs = {
  env                   = local.account_vars.locals.env
  region                = local.account_vars.locals.region
  global_tags           = local.account_vars.locals.global_tags
  create_app_env_bucket = local.account_vars.locals.iam_role.create_app_env_bucket
  service_linked_role_suffix = local.account_vars.locals.env
}