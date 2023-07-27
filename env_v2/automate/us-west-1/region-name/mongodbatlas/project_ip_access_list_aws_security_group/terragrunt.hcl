terraform {
  source = "/home/ec2-user/infra-terraform//modules_v2/mongodbatlas/project_ip_access_list_aws_security_group"
}

include {
  path = find_in_parent_folders()
}

dependency "security_group_mongodb_atlas_access" {
  config_path = "../mongodb_atlas_access"
}

dependency "project" {
  config_path = "../project"
}

// Cannot use aws security groups as an access list entry without a vpc peering connection.
dependency "network_peering" {
  config_path = "../network_peering"
}

inputs = {
  project_id = dependency.project.outputs.id
  aws_security_group_id = dependency.security_group_mongodb_atlas_access.outputs.id
  peer_id = dependency.network_peering.outputs.peer_id
}
