locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out common variables for reuse
  project = local.account_vars.locals.project
  env     = local.environment_vars.locals.environment
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "${get_parent_terragrunt_dir()}/../terragrunt_infrastructure_modules//service_accounts"
}

dependencies {
  paths = ["${get_terragrunt_dir()}/../enable_apis"]
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  project                 = "${local.project}"
  account_id_bastion_host = "bastion-host-sa-${local.env}"
  account_id_iap_ssh      = "iap-ssh-sa-${local.env}"
  account_id_composer     = "composer-sa-${local.env}"
}
