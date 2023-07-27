terraform {
  source = "/home/ec2-user/infra-terraform//modules_v2/elasticache/elasticache_redis_server"
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
  vpc_id = dependency.vpc.outputs.id
  name = local.account_vars.locals.elasticache.redis-server.name
  description = "Applies to ElastiCache-Redis-Server."
  tags = local.account_vars.locals.elasticache.redis-server.tags
  global_tags = local.account_vars.locals.global_tags
}
