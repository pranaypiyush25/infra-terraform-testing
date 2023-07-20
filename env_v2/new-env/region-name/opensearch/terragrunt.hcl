terraform {
  source = "/home/ec2-user/infra-terraform//modules_v2/opensearch?ref=v2"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id
  cidr_block = dependency.vpc.outputs.vpc_cidr_block
  subnet_ids = dependency.vpc.outputs.subnets_worker_layer
  domain = local.account_vars.locals.opensearch.domain_name
  instance_type = local.account_vars.locals.opensearch.instance_type
  instance_count = local.account_vars.locals.opensearch.instance_count
  engine_version = local.account_vars.locals.opensearch.engine_version
  tags = local.account_vars.locals.opensearch.tags
  global_tags = local.account_vars.locals.global_tags
  aws_region_name = local.account_vars.locals.region
}
