terraform {
  source = "/home/ec2-user/infra-terraform//modules_v2/mongodbatlas/project"
}

include {
  path = find_in_parent_folders()
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}


inputs = {
  org_id = local.account_vars.locals.mongodbatlas.org_id
  name = local.account_vars.locals.mongodbatlas.project.name
}
