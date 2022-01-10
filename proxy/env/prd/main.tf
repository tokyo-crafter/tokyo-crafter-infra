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
  profile    = "default"
  region     = "ap-northeast-1"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
  assume_role {
    role_arn = "" # TODO RoleArn
  }
}

module "aws-lightsail" {
  source = "../../module/aws/lightsail-cluster"

  aws_access_key_id     = var.aws_access_key_id
  aws_secret_access_key = var.aws_secret_access_key
  instance_name_prefix  = var.group_name + "-proxy"
  tag_group             = var.group_name
  ssh_public_key        = var.ssh_public_key
  ssh_private_key       = var.ssh_private_key
}
