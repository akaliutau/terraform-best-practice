provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = ">= 0.14"
  required_providers {
    aws = "= 3.76.1"
  }
}

# NOTE: this resource will be generated only if it does not exist in state
resource "random_string" "rand" {
  length  = 24
  special = false
  upper   = false
}

locals {
  namespace = substr(join("-", [var.name, random_string.rand.result]), 0, 24)
}

module "iam" {
  source = "./modules/iam"
  namespace = local.namespace
  deployment_policy = file("./policies/simple_ec2_policy.json")
}

module "s3-terraform-backend" {
  source         = "./modules/s3config"
  principal_arns = [module.iam.codebuild_role_arn]
}

module "codepipeline" {
  source           = "./modules/codepipeline"

  namespace        = local.namespace
  auto_apply       = true
  source_code_repo = var.source_code_repo

  environment      = {
    DESTROY = 0
  }

  s3_backend_config = module.s3-terraform-backend.config

  codebuild_role_arn = module.iam.codebuild_role_arn
  codepipeline_role_arn = module.iam.pipeline_role_arn

  codebuild_role_name = module.iam.codebuild_role_name
  codepipeline_role_name = module.iam.pipeline_role_name
}

