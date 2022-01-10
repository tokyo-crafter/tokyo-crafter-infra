terraform {
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

locals {
  bundle_id    = "nano_2_0"
  blueprint_id = "amazon_linux_2"
  ssh_user     = "ec2-user"

  # Availability zones in ap-northeast-1
  zones          = ["a", "b", "c"]
  instance_idxes = range(var.lightsail_instance_count)

  # instance
  instances = [
  for i in local.instance_idxes : {
    name           = var.lightsail_instance_name + "-" + i
    az             = zones[i % 3]
    static_ip_name = var.lightsail_instance_name + "-" + i + "-" + "ip"
    index          = i
  }
  ]
}

## define ssh key
resource "aws_lightsail_key_pair" "ssh-key" {
  name       = "ssh_key_pair"
  public_key = var.ssh_public_key
}

## create instance
resource "aws_lightsail_instance" "instance" {
  for_each = {for instance in local.instances : instance["name"] => instance}

  name              = each.value["name"]
  key_pair_name     = aws_lightsail_key_pair.ssh-key.name
  availability_zone = each.value["az"]
  blueprint_id      = local.blueprint_id
  bundle_id         = local.bundle_id
  tags              = {
    group : var.lightsail_tag_group
  }
}

## create static ip
resource "aws_lightsail_static_ip" "static-ip" {
  for_each = {for instance in local.instances : instance[name] => instance}

  name = each.value["static_ip_name"]
}

## attach static ip
resource "aws_lightsail_static_ip_attachment" "attach-static-ip" {
  depends_on = [aws_lightsail_instance.instance, aws_lightsail_static_ip.static-ip]

  for_each = {for instance in local.instances : instance[name] => instance}

  instance_name  = each.value["name"]
  static_ip_name = each.value["static_ip_name"]
}

## firewall
resource "aws_lightsail_instance_public_ports" "firewall" {
  for_each = {for instance in values(aws_lightsail_instance.instance)[*] : instance[name] => instance}

  instance_name = each.value["name"]

  port_info {
    protocol  = "tcp"
    from_port = 25565
    to_port   = 25565
    cidrs     = ["0.0.0.0"] # global
  }

  port_info {
    protocol  = "tcp"
    from_port = 0
    to_port   = 0
    cidrs     = var.tf_cloud_ip_ranges # restrict public access
  }
}

## provisioner
resource "null_resource" "provisioner" {
  depends_on = [aws_lightsail_static_ip_attachment, aws_lightsail_instance_public_ports.firewall]

  for_each = {for instance in values(aws_lightsail_instance.instance)[*] : instance[name] => instance}

  connection {
    type        = "ssh"
    host        = each["public_ip_address"]
    user        = each["username"]
    private_key = var.ssh_private_key
    timeout     = "2m"
  }

  provisioner "file" {
    source      = "setup.sh"
    destination = "/tmp/setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup.sh",
      "/tmp/setup.sh > /tmp/setup.log"
    ]
  }
}
