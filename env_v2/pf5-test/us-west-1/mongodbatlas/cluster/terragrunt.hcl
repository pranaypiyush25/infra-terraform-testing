terraform {
  source = "/home/ec2-user/infra-terraform//modules_v2/mongodbatlas/cluster"
}

include {
  path = find_in_parent_folders()
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

dependency "project" {
  config_path = "../project"
}


inputs = {
  project_id = dependency.project.outputs.id
  name = local.account_vars.locals.mongodbatlas.project.cluster.name
  mongo_db_major_version = local.account_vars.locals.mongodbatlas.project.cluster.mongo_db_major_version
  disk_size_gb = local.account_vars.locals.mongodbatlas.project.cluster.disk_size_gb
  provider_instance_size_name = local.account_vars.locals.mongodbatlas.project.cluster.provider_instance_size_name
  aws_region_name = local.account_vars.locals.region
}
