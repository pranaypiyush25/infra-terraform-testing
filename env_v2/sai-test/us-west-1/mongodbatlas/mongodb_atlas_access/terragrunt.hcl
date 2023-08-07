terraform {
  source = "/home/ec2-user/infra-terraform//modules_v2/mongodbatlas/mongodb_atlas_access"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../../vpc"
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id

  name = local.account_vars.locals.mongodbatlas.access.name
  description = "Stacks/Servers with this group will have access to MongoDB Atlas cluster"
  tags = local.account_vars.locals.mongodbatlas.access.tags
  global_tags = local.account_vars.locals.global_tags
}
