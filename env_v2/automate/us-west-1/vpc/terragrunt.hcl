terraform {
  source = "/home/ec2-user/infra-terraform//modules_v2/vpc"
}

include {
  path = find_in_parent_folders()
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

inputs = {
  tags                = local.account_vars.locals.vpc.tags
  default_vpc         = local.account_vars.locals.vpc.default_vpc
  existing_vpc_id     = local.account_vars.locals.vpc.existing_vpc_id
  existing_igw_id     = local.account_vars.locals.vpc.existing_igw_id
  name_prefix         = local.account_vars.locals.vpc.subnet.name_prefix
  cluster_AZ          = local.account_vars.locals.vpc.subnet.cluster_AZ
  cluster_EIP         = local.account_vars.locals.vpc.subnet.cluster_EIP
  worker_AZ           = local.account_vars.locals.vpc.subnet.worker_AZ
  worker_EIP          = local.account_vars.locals.vpc.subnet.worker_EIP
  public_nat_cidr     = local.account_vars.locals.vpc.subnet.public_nat_cidr
  cluster_cidr        = local.account_vars.locals.vpc.subnet.cluster_cidr
  workernode_cidr     = local.account_vars.locals.vpc.subnet.workernode_cidr
  create_vpc          = local.account_vars.locals.vpc.create_vpc
  vpc_cidr_block      = local.account_vars.locals.vpc.vpc_cidr_block
  create_igw          = local.account_vars.locals.vpc.create_igw
  region              = local.account_vars.locals.region
  public_cluster      = local.account_vars.locals.public_cluster
  global_tags         = local.account_vars.locals.global_tags
  
}