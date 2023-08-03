terraform {
  source = "/home/ec2-user/infra-terraform//modules_v2/secrets_manager"
}

include {
  path = find_in_parent_folders()
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

inputs = {
  name               = local.account_vars.locals.secrets_manager.name
  env                = local.account_vars.locals.env
  region             = local.account_vars.locals.region
  global_tags        = local.account_vars.locals.global_tags
}