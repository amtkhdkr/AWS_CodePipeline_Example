# ---------------------------------------------------------------------------------------------------------------------
# AWS PROVIDER USING TF CLI
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  profile = "default-ecs"
  version = "~> 2.25"
  region  = "${var.aws_region}"
}

terraform {
  required_version = "~>0.12"
  backend "remote" {
    organization = "aws-isv"

    workspaces {
      name = "petclinic-fargate"
    }
  }
}