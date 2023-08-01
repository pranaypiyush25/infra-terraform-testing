terraform {
  source = "/home/ec2-user/infra-terraform//modules_v2/mongodbatlas/network_peering"
}

include {
  path = find_in_parent_folders()
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

dependency "vpc" {
  config_path = "../../vpc"
}

dependency "project" {
  config_path = "../project"
}

dependency "cluster" {
  config_path = "../cluster"
}


inputs = {
  accepter_region_name = local.account_vars.locals.region
  vpc_id = dependency.vpc.outputs.id
  route_table_cidr_block = local.account_vars.locals.vpc.cidr_block
  project_id = dependency.project.outputs.id
  container_id = dependency.cluster.outputs.container_id
}
