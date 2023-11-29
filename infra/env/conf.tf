locals {
  module_name = REPLACE_ME
  region_name = "eu-west-1"
  envs        = {
    dev = {
      stage = "dev"
    },
    beta = {
      stage = "beta"
    },
    prod = {
      stage = "prod"
    }
  }
  current_env = local.envs[terraform.workspace]
}


output "region_name" {
  value = local["region_name"]
}

output "stage" {
  value = local.current_env["stage"]
}


output "common_tags" {
  value = {
    module      = local.module_name
    tech-module = REPLACE_ME
    stage       = local.current_env["stage"]
  }
}
