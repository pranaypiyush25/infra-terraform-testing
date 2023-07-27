terraform {
  source = "/home/ec2-user/infra-terraform//modules_v2/eks_controlplane"
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

dependency "iam_role" {
  config_path = "../../iam_role"
}

inputs = {
  private_endpoint      = true
  servicename           = "eksworker"
  controlplane_iam_role = dependency.iam_role.outputs.EKSControlPlaneRole
  vpc_id                = dependency.vpc.outputs.vpc_id
  vpc_cidr_block        = dependency.vpc.outputs.vpc_cidr_block
  name_prefix           = local.account_vars.locals.cluster_name
  k8s_version           = local.account_vars.locals.k8s_version
  public_endpoint       = local.account_vars.locals.public_cluster
  env                   = local.account_vars.locals.env
  create_vpc            = local.account_vars.locals.vpc.create_vpc
  alertgroup            = local.account_vars.locals.alertgroup
  global_tags           = local.account_vars.locals.global_tags
  region                = local.account_vars.locals.region
}