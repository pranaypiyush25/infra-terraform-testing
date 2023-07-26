terraform {
  source = "/home/ec2-user/infra-terraform//modules_v2/elasticache/replication_groups/redis_server"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../../../vpc"
}

dependency "elasticache_redis_server_security_group" {
  config_path = "../../elasticache_redis_server"
}

dependency "redis_subnet_group" {
  config_path = "../../subnet_groups/redis"
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

inputs = {
  description = ""
  num_node_groups = local.account_vars.locals.elasticache.replication_groups.num_node_groups
  replicas_per_node_group = local.account_vars.locals.elasticache.replication_groups.replicas_per_node_group
  port = local.account_vars.locals.elasticache.replication_groups.port
  automatic_failover_enabled = local.account_vars.locals.elasticache.replication_groups.automatic_failover_enabled
  at_rest_encryption_enabled = local.account_vars.locals.elasticache.replication_groups.at_rest_encryption_enabled
  multi_az_enabled = local.account_vars.locals.elasticache.replication_groups.
  node_type = local.account_vars.locals.elasticache.replication_groups.
  engine_version = local.account_vars.locals.elasticache.replication_groups.
  parameter_group_name = local.account_vars.locals.elasticache.replication_groups.
  id = local.account_vars.locals.elasticache.replication_groups.id
  snapshot_window = local.account_vars.locals.elasticache.replication_groups.snapshot_window
  availability_zones = [ local.account_vars.locals.vpc.subnets.worker_AZ ]
  maintenance_window = local.account_vars.locals.elasticache.replication_groups.maintenance_window
  subnet_group_name = dependency.redis_subnet_group.outputs.name
  security_group_ids = [ dependency.elasticache_redis_server_security_group.outputs.id ]
  snapshot_retention_limit = local.account_vars.locals.elasticache.replication_groups.
  transit_encryption_enabled = local.account_vars.locals.elasticache.replication_groups.transit_encryption_enabled
  global_tags = local.account_vars.locals.global_tags
}
