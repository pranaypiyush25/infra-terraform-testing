variable "region" {}
variable "env" {}
variable "global_tags" {
  description = "Map of global tags to be added"
  type        = map(string)
}
variable "create_app_env_bucket" {}
variable "service_linked_role_suffix" {}



provider "aws" {
  region = var.region
}

module "iamrole" {
  source = "/home/ec2-user/code-sai-test/infra-terraform//modules_v2/iam_roles"
  env                   = var.env
  region                = var.region
  global_tags           = var.global_tags
  create_app_env_bucket = var.create_app_env_bucket
  service_linked_role_suffix = var.env
}