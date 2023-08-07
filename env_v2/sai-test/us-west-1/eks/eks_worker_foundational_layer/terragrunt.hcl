terraform {
  source = "/home/ec2-user/infra-terraform//modules_v2/eks_workers"
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

inputs = {
  vpc_id                = dependency.vpc.outputs.vpc_id 
  name_prefix           = local.account_vars.locals.cluster_name
  env                   = local.account_vars.locals.env
  cluster_name          = local.account_vars.locals.cluster_name
  region                = local.account_vars.locals.region
  global_tags           = local.account_vars.locals.global_tags
  asg_prefix            = local.account_vars.locals.worker.foundational_layer.asg_prefix
  instance_type         = local.account_vars.locals.worker.foundational_layer.instance_type
  keyname               = local.account_vars.locals.worker.keyname
  kubelet_args          = local.account_vars.locals.worker.foundational_layer.kubelet_args
  ami                   = local.account_vars.locals.worker.foundational_layer.ami_id
  root_volume_size      = local.account_vars.locals.worker.foundational_layer.root_volume_size
  root_volume_type      = local.account_vars.locals.worker.foundational_layer.root_volume_type
  worker_asg_role       = local.account_vars.locals.worker.foundational_layer.worker_asg_role
  term_policy           = local.account_vars.locals.worker.foundational_layer.term_policy
  min_instance_count    = local.account_vars.locals.worker.foundational_layer.min_instance_count
  max_instance_count    = local.account_vars.locals.worker.foundational_layer.max_instance_count
  desired_instance_count= local.account_vars.locals.worker.foundational_layer.desired_instance_count
  workernode_cidr       = local.account_vars.locals.vpc.subnet.workernode_cidr
}