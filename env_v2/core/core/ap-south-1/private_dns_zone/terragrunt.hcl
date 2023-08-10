terraform {
  source = "/home/ec2-user/infra-terraform//modules_v2/privatehostedzone"
}

include {
  path = find_in_parent_folders()
}
dependency "argoapps" {
  config_path = "../argoapps"
  skip_outputs = "true"
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

inputs = {
  cluster_name     = local.account_vars.locals.cluster_name
  domain           = local.account_vars.locals.private_hosted_zone.domain
  records          = local.account_vars.locals.private_hosted_zone.records
  create_vpc       = local.account_vars.locals.vpc.create_vpc
}