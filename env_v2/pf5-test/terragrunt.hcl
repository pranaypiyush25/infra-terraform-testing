remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {

    bucket = "integrator-pf5-test-terraform-eks-state-us-west-1" # Bucket Name to Store State file

    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-west-1" # Bucket Region
    encrypt        = true
    
  }
}

locals {

  #global
  env                    = "pf5-test"
  region                 = "us-west-1"
  public_cluster         = "true" # true/false
  k8s_version            = "1.23"
  cluster_name           = "pf5-test-aws-eks-us-west-1"
  global_tags            = {
    "Environment" = "pf5-test-aws-eks-us-west-1"
  }

  alertgroup             = "devops_team"

  iam_role = {
    create_app_env_bucket      = "true" # true/false to create s3 env vars bucket
  }

  vpc = {
    existing_vpc_id   = ""       # provide vpc-id to use existing vpc 
    existing_igw_id   = ""       # provide igw-id to use existing vpc
    default_vpc       = "true"  # true to use default_vpc
    vpc_cidr_block    = "172.31.0.0/16"       # must need to be provided
    create_vpc        = "false"   # false if no new-vpc/default-vpc needed
    create_igw        = "false"   # false if no new-vpc/default-vpc needed
    subnet = {
      name_prefix                          = "pf5-test-aws-eks-us-west-1"
      cluster_AZ                           = ["us-west-1a","us-west-1b"]         # list the cluster AZ,      i.e   "ap-south-1a","ap-south-1b"
      cluster_EIP                          = ["52.52.212.157","13.57.63.230"]         # list the exisitng EIPs,   i.e   "20.20.20.20", "30.30.30.30"
      worker_AZ                            = ["us-west-1a","us-west-1b"]         # list the worker AZ,       i.e   "ap-south-1a","ap-south-1b"
      worker_EIP                           = ["13.57.137.178","54.215.100.11"]         # list the exisitng EIPs,   i.e   "20.20.20.20", "30.30.30.30"
      public_nat_cidr                      = ["172.31.148.0/24","172.31.149.0/24"]         # list the Public CIDR,     i.e   "172.31.250.0/24", "172.31.251.0/24"
      cluster_cidr                         = ["172.31.158.0/24","172.31.159.0/24"]         # list the Cluster CIDR,    i.e   "172.31.120.0/24", "172.31.121.0/24"
      workernode_cidr                      = ["172.31.168.0/24","172.31.169.0/24"]         # list the Worker CIDR,     i.e   "172.31.130.0/24", "172.31.131.0/24"
    }
    tags = {  
      SERVICENAME    = "pf5-test"
    }
  }
  
  worker = {
    keyname                               = "pf5-test-key-pair"     # create ssh key name and update
    generic = {
      instance_type                        = "t3.large"
      asg_prefix                           = "generic"
      min_instance_count                   = "1"
      max_instance_count                   = "4"
      desired_instance_count               = "1"
      ami_id                               = "ami-0109642eee1718e95"
      root_volume_size                     = "100"
      root_volume_type                     = "gp3"
      worker_asg_role                      = "AWSServiceRoleForAutoScaling_pf5-test"
      term_policy                          = "OldestLaunchConfiguration"
      kubelet_args                         = "--use-max-pods 205"
    }  
    foundational_layer = {
      instance_type                        = "t3.large"
      asg_prefix                           = "foundational_layers"
      min_instance_count                   = "1"
      max_instance_count                   = "4"
      desired_instance_count               = "1"
      ami_id                               = "ami-0109642eee1718e95"
      root_volume_size                     = "100"
      root_volume_type                     = "gp3"
      worker_asg_role                      = "AWSServiceRoleForAutoScaling_pf5-test"
      term_policy                          = "OldestLaunchConfiguration"
      kubelet_args                         = "--use-max-pods 205 --kubelet-extra-args '--register-with-taints=affinity=foundational_layer:NoSchedule'"
    }

  }

  argocd = {
    version_argocd              = "5.5.3"
    istio_apply_module          = "true"
    foundationlayer_namespace   = [{ "namespace_name" : "argocd" },{ "namespace_name" : "istio-system" },{ "namespace_name" : "istio-gateway" }] 
    app_namespace               = [{"namespace_name" : "core" },{ "namespace_name" : "io" },
                                { "namespace_name" : "ia" },{ "namespace_name" : "istio-ingress" },{ "namespace_name" : "ui" }, { "namespace_name" : "testing" }] 
  }

  mongodbatlas = {
    access = {
      name = ""
      tags = {
        Name = "MongoDB Atlas Access for pf5-test"
      }
    }
    org_id = "5d1b2061d5ec130eb8a22c12"
    project = {
      name = "pf5-test"
      cluster = {
        name = "pf5-test"
        mongo_db_major_version = "4.4"
        provider_instance_size_name = "M10"
        disk_size_gb = 40
      }
    }
  }

  elasticache = {
    subnet_groups = {
      name = "elasticache-pf5-test"
    }
    redis-server = {
      name = "redis-server-pf5-test"
      tags = {
        Name = "ElasticCache Redis Server for pf5-test"
      }
    }
    replication_groups = {
      id = "redis-server-pf5-test"
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
    domain_name = "pf5-test"
    instance_type = "m6g.large.search"
    instance_count = 2
    engine_version = "OpenSearch_2.5"
    volume_size = 100
    tags = {
      Name = "OpenSearch Service for pf5-test"
    }
  }

  secrets_manager = {
    name = "pf5-test-secrets"
  }

  private_hosted_zone = {
    domain = "celigo.io" #add domain name
    records= ["*.celigo.io","*.ia.celigo.io"] #add cname records
  }
}
