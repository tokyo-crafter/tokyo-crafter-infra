## local variables
locals {
  # Availability zones in ap-northeast-1
  zones          = ["a", "b", "c"]
  instance_idxes = range(var.instance_count)

  # instance
  instances = [
  for i in local.instance_idxes : {
    # ${var.instance_name_prefix}-a-1, ${var.instance_name_prefix}-b-1, ${var.instance_name_prefix}-c-1, ${var.instance_name_prefix}-a-2, ...
    name = join("-", [var.instance_name_prefix, local.zones[i % length(local.zones)], i / length(local.zones) + 1])
    # ap-northeast-1a, ap-northeast-1b, ap-northeast-1c
    az   = join("", [var.region, local.zones[i % length(local.zones)]])
  }
  ]
}

## define ssh key
resource "aws_lightsail_key_pair" "ssh-key" {
  name       = "ssh_key_pair"
  public_key = var.ssh_public_key
}

## create lightsail instance
module "lightsail" {
  for_each = {for instance in local.instances : instance["name"] => instance}

  source = "../lightsail"

  instance_name     = each.value["name"]
  availability_zone = each.value["az"]
  tag_group         = var.tag_group
  key_pair_name     = aws_lightsail_key_pair.ssh-key.name
  ssh_private_key   = var.ssh_private_key
}
