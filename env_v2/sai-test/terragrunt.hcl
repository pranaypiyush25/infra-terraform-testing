remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {

    bucket = "integrator-sai-test-terraform-eks-state-us-west-1" # Bucket Name to Store State file

    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-west-1" # Bucket Region
    encrypt        = true
    
  }
}

locals {

  #global
  env                    = "sai-test"
  region                 = "us-west-1"
  public_cluster         = "false" # true/false
  k8s_version            = "1.23"
  cluster_name           = "sai-test-aws-eks-us-west-1"
  global_tags            = {
    "Environment" = "sai-test-aws-eks-us-west-1"
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
      name_prefix                          = "sai-test-aws-eks-us-west-1"
      cluster_AZ                           = ["us-west-1a","us-west-1c"]        # list the cluster AZ,      i.e   "ap-south-1a","ap-south-1b"
      cluster_EIP                          = ["54.219.195.50", "52.9.7.102"]         # list the exisitng EIPs,   i.e   "20.20.20.20", "30.30.30.30"
      worker_AZ                            = ["us-west-1a","us-west-1c"]         # list the worker AZ,       i.e   "ap-south-1a","ap-south-1b"
      worker_EIP                           = [ "13.52.204.132", "54.177.74.32"]         # list the exisitng EIPs,   i.e   "20.20.20.20", "30.30.30.30"
      public_nat_cidr                      = ["172.31.170.0/24", "172.31.171.0/24"]        # list the Public CIDR,     i.e   "172.31.250.0/24", "172.31.251.0/24"
      cluster_cidr                         = ["172.31.180.0/24", "172.31.181.0/24"]         # list the Cluster CIDR,    i.e   "172.31.120.0/24", "172.31.121.0/24"
      workernode_cidr                      = ["172.31.190.0/24", "172.31.191.0/24"]        # list the Worker CIDR,     i.e   "172.31.130.0/24", "172.31.131.0/24"
    }
    tags = {  
      SERVICENAME    = "sai-test"
    }
  }
  
  worker = {
    keyname                               = "integrator-sai-test"     # create ssh key name and update
    generic = {
      instance_type                        = "t3.large"
      asg_prefix                           = "generic"
      min_instance_count                   = "1"
      max_instance_count                   = "4"
      desired_instance_count               = "1"
      ami_id                               = "ami-06c28dd441f3817c0"
      root_volume_size                     = "100"
      root_volume_type                     = "gp3"
      worker_asg_role                      = "AWSServiceRoleForAutoScaling_sai-test"
      term_policy                          = "OldestLaunchConfiguration"
      kubelet_args                         = "--use-max-pods 205"
    }  
    foundational_layer = {
      instance_type                        = "t3.large"
      asg_prefix                           = "foundational_layers"
      min_instance_count                   = "1"
      max_instance_count                   = "4"
      desired_instance_count               = "1"
      ami_id                               = "ami-06c28dd441f3817c0"
      root_volume_size                     = "100"
      root_volume_type                     = "gp3"
      worker_asg_role                      = "AWSServiceRoleForAutoScaling_sai-test"
      term_policy                          = "OldestLaunchConfiguration"
      kubelet_args                         = "--use-max-pods 205 --kubelet-extra-args '--register-with-taints=affinity=foundational_layer:NoSchedule'"
    }

  }

  argocd = {
    version_argocd              = "5.5.3"
    istio_apply_module          = "true"
    aws_secretsmanager_arn      = "arn:aws:secretsmanager:us-west-1:341118756977:secret:eks-provisioning-rFaxUl"
    foundationlayer_namespace   = [{ "namespace_name" : "argocd" },{ "namespace_name" : "istio-system" },{ "namespace_name" : "istio-gateway" }] 
    app_namespace               = [{"namespace_name" : "core" },{ "namespace_name" : "io" },
                                { "namespace_name" : "ia" },{ "namespace_name" : "istio-ingress" },{ "namespace_name" : "ui" }, { "namespace_name" : "testing" }] 
  }

  private_hosted_zone = {
    domain = "celigo.io" #add domain name
    records= ["*.celigo.io","*.ia.celigo.io"] #add cname records
  }
}
