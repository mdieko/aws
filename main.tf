terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.1"
    }
  }
  backend "s3" {
    bucket                 = "osana-terraform-tfstate"
    region                 = "us-east-1"       
    key                    = "osana-infra.tfstate"
    workspace_key_prefix   = "infra"
    encrypt                = true
  }
}

provider "aws" {
  region  = var.region

  assume_role {
    role_arn    = "arn:aws:iam::${var.account_id}:role/TerraformServicesAdminAccess"
  }
}

module "vpc" {
  source = "./modules/vpc"
}