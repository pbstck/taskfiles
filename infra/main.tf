terraform {
  backend "s3" {
    bucket = "pubstack-terraform-backend"
    key    = REPLACE_ME
    region = "eu-west-1"
  }
}

module "env" {
  source = "./env"
}

variable "git_revision" {}

provider "aws" {
  region = module.env.region_name
  assume_role {
    role_arn = var.workspace_iam_roles[local.workspace]
  }
}


variable "workspace_iam_roles" {
  default = {
    prod = "arn:aws:iam::031816568746:role/terraform"
    beta = "arn:aws:iam::674067039865:role/terraform"
    dev  = "arn:aws:iam::997509706121:role/terraform"
  }
}

locals {
  workspace = contains(["dev", "beta", "prod"], terraform.workspace) ? terraform.workspace : "dev"
}
