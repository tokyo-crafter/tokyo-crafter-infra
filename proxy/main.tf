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
  region     = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

module "lightsail-cluster" {
  source = "./modules/aws/lightsail-cluster"

  instance_name_prefix = join("-", [var.group_name, var.environment, "proxy"])
  region               = var.aws_region
  tag_group            = var.group_name
  instance_count       = var.proxy_replicas
  ssh_public_key       = var.ssh_public_key
  ssh_private_key      = var.ssh_private_key
}
