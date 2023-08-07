terraform {
  source = "/home/ec2-user/infra-terraform//modules_v2/service_account"
}

include {
  path = find_in_parent_folders()
}

dependency "eks" {
  config_path = ["../eks/eks_controlplane","../eks/eks_worker_foundational_layer","../eks/eks_worker_foundational_layer"]
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

inputs = {
  env          = local.account_vars.locals.env
  region       = local.account_vars.locals.region
  cluster_name = local.account_vars.locals.cluster_name
  global_tags  = local.account_vars.locals.global_tags
}