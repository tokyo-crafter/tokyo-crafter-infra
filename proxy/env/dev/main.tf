terraform {
  cloud {
    organization = "tokyo-crafter"

    workspaces {
      name = "proxy-dev"
    }
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

## refers to ~/.aws/credentials. AWS CLI credentials
provider "aws" {
  region     = "ap-northeast-1"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

module "aws-lightsail" {
  source = "../../module/aws/lightsail-cluster"

  instance_name_prefix = var.group_name + "-proxy"
  tag_group            = var.group_name
  instance_count       = 1
  ssh_public_key       = var.ssh_public_key
  ssh_private_key      = var.ssh_private_key
}
