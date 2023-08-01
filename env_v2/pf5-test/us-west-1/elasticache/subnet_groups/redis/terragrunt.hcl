terraform {
  source = "/home/ec2-user/infra-terraform//modules_v2/elasticache/subnet_groups/redis"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../../../vpc"
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

inputs = {
  name = local.account_vars.locals.elasticache.subnet_groups.name
  description = "redis subnet group"
  subnet_ids = [ dependency.vpc.subnets_Public ]
}
