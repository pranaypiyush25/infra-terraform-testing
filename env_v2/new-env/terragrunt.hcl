remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {

    bucket = "integrator-<new-env>-terragrunt-terraform-eks-state-<region-name>" # Bucket Name to Store State file

    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "<region-name>" # Bucket Region
    encrypt        = true
    
  }
}

locals {

  #global
  env                    = "<new-env>"
  region                 = "<region-name>"
  public_cluster         = "<isPublicCluster>" # true/false
  k8s_version            = "1.23"
  cluster_name           = "<new-env>-aws-eks-<region-name>"
  global_tags            = {
    "Environment" = "<new-env>-aws-eks-<region-name>"
  }

  alertgroup             = "devops_team"

  iam_role = {
    create_app_env_bucket      = "false" # true/false to create s3 env vars bucket
  }

  vpc = {
    existing_vpc_id   = ""       # provide vpc-id to use existing vpc 
    existing_igw_id   = ""       # provide igw-id to use existing vpc
    default_vpc       = "false"  # true to use default_vpc
    vpc_cidr_block    = ""       # must need to be provided
    create_vpc        = "true"   # false if no new-vpc/default-vpc needed
    create_igw        = "true"   # false if no new-vpc/default-vpc needed
    subnet = {
      name_prefix                          = "<new-env>-aws-eks-<region-name>"
      cluster_AZ                           = [ ]         # list the cluster AZ,      i.e   "ap-south-1a","ap-south-1b"
      cluster_EIP                          = [ ]         # list the exisitng EIPs,   i.e   "20.20.20.20", "30.30.30.30"
      worker_AZ                            = [ ]         # list the worker AZ,       i.e   "ap-south-1a","ap-south-1b"
      worker_EIP                           = [ ]         # list the exisitng EIPs,   i.e   "20.20.20.20", "30.30.30.30"
      public_nat_cidr                      = [ ]         # list the Public CIDR,     i.e   "172.31.250.0/24", "172.31.251.0/24"
      cluster_cidr                         = [ ]         # list the Cluster CIDR,    i.e   "172.31.120.0/24", "172.31.121.0/24"
      workernode_cidr                      = [ ]         # list the Worker CIDR,     i.e   "172.31.130.0/24", "172.31.131.0/24"
    }
    tags = {  
      SERVICENAME    = "<new-env>"
    }
  }
  
  worker = {
    keyname                               = "<key-pair-name>"     # create ssh key name and update
    generic = {
      instance_type                        = "t3.large"
      asg_prefix                           = "generic"
      min_instance_count                   = "1"
      max_instance_count                   = "4"
      desired_instance_count               = "1"
      ami_id                               = "ami-0d9c28c76ecc3d211"
      root_volume_size                     = "100"
      root_volume_type                     = "gp3"
      worker_asg_role                      = "AWSServiceRoleForAutoScaling_<new-env>"
      term_policy                          = "OldestLaunchConfiguration"
      kubelet_args                         = "--use-max-pods 205"
    }  
    foundational_layer = {
      instance_type                        = "t3.large"
      asg_prefix                           = "foundational_layers"
      min_instance_count                   = "1"
      max_instance_count                   = "4"
      desired_instance_count               = "1"
      ami_id                               = "ami-0d9c28c76ecc3d211"
      root_volume_size                     = "100"
      root_volume_type                     = "gp3"
      worker_asg_role                      = "AWSServiceRoleForAutoScaling_<new-env>"
      term_policy                          = "OldestLaunchConfiguration"
      kubelet_args                         = "--use-max-pods 205 --kubelet-extra-args '--register-with-taints=affinity=foundational_layer:NoSchedule'"
    }

  }

  argocd = {
    version_argocd              = "5.5.3"
    istio_apply_module          = "false"
    foundationlayer_namespace   = [ { "namespace_name" : "argocd" }] 
    app_namespace               = [] #please provide if extra namespaces are required
  }

  mongodbatlas = {
    access = {
      name = ""
      tags = {
        Name = "MongoDB Atlas Access for <new-env>"
      }
    }
    org_id = "5d1b2061d5ec130eb8a22c12"
    project = {
      name = "<new-env>"
      cluster = {
        name = "<new-env>"
        mongo_db_major_version = "4.4"
        provider_instance_size_name = "M10"
        disk_size_gb = 40
      }
    }
  }

  elasticache = {
    subnet_groups = {
      name = "elasticache-<new-env>"
    }
    redis-server = {
      name = "redis-server-<new-env>"
      tags = {
        Name = "ElasticCache Redis Server for <new-env>"
      }
    }
    replication_groups = {
      id = "redis-server-<new-env>"
      num_node_groups = 1
      replicas_per_node_group = 1
      port = 6379
      automatic_failover_enabled = true
      at_rest_encryption_enabled = true
      multi_az_enabled = true
      node_type = ""
      engine_version = "5.0.6"
      parameter_group_name = "default.redis5.0"
      snapshot_retention_limit = 0
      transit_encryption_enabled = true
      snapshot_window = "07:00-08:00"
      maintenance_window = "mon:06:00-mon:07:00"
    }
  }

  opensearch = {
    domain_name = "<new-env>"
    instance_type = "m6g.large.search"
    instance_count = 2
    engine_version = "OpenSearch_2.5"
    volume_size = 100
    tags = {
      Name = "OpenSearch Service for <new-env>"
    }
  }

  secrets_manager = {
    name = "<secrets-store-name>"
  }

  private_hosted_zone = {
    domain = "celigo.io" #add domain name
    records= ["*.celigo.io","*.ia.celigo.io"] #add cname records
  }
}