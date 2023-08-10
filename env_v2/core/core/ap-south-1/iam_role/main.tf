variable "region" {}
variable "env" {}




provider "aws" {
  region = var.region
}

module "iamrole" {
  source = "/home/ec2-user/code-sai-test/infra-terraform//modules_v2/iam_roles"

}