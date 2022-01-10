terraform {
  cloud {
    organization = "tokyo-crafter"

    workspaces {
      name = "proxy-dev"
    }
  }
}

module "tfc-ip-ranges" {
  source = "../../module/tfc/ipranges"
}


module "aws-lightsail" {
  source                  = "../../module/aws/lightsail"
  aws_access_key_id       = var.aws_access_key_id
  aws_secret_access_key   = var.aws_secret_access_key
  lightsail_instance_name = var.group_name + "-proxy"
  lightsail_tag_group     = var.group_name
  ssh_public_key          = var.ssh_public_key
  ssh_private_key         = var.ssh_private_key
  tf_cloud_ip_ranges      = module.tfc-ip-ranges.terraform_cloud_sentinel_ip_ranges
}
