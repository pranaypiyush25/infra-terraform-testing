variable "region" {}
variable "env" {}




provider "aws" {
  region = var.region
}

module "iamrole" {
  source = "/home/ec2-user/code-sai-test/infra-terraform//modules_v2/iam_roles"
  env                   = local.account_vars.locals.env
  region                = local.account_vars.locals.region
  global_tags           = local.account_vars.locals.global_tags
  create_app_env_bucket = local.account_vars.locals.iam_role.create_app_env_bucket
  service_linked_role_suffix = local.account_vars.locals.env
}