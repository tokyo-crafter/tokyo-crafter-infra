## local variables
locals {
  bundle_id      = "nano_2_0"
  blueprint_id   = "amazon_linux_2"
  ssh_user       = "ec2-user"
  static_ip_name = join("-", [var.instance_name, "ip"])
}

## create instance
resource "aws_lightsail_instance" "instance" {
  name              = var.instance_name
  key_pair_name     = var.key_pair_name
  availability_zone = var.availability_zone
  blueprint_id      = local.blueprint_id
  bundle_id         = local.bundle_id

  tags = {
    group : var.tag_group
  }
}

## create static ip
resource "aws_lightsail_static_ip" "static-ip" {
  name = local.static_ip_name
}

## attach static ip
resource "aws_lightsail_static_ip_attachment" "attach-static-ip" {
  instance_name  = aws_lightsail_instance.instance.name
  static_ip_name = aws_lightsail_static_ip.static-ip.name
}

## firewall
resource "aws_lightsail_instance_public_ports" "firewall" {
  instance_name = aws_lightsail_instance.instance.name

  port_info {
    protocol  = "tcp"
    from_port = 25565
    to_port   = 25565
  }

  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
  }
}

## provisioner
resource "null_resource" "provisioner" {

  connection {
    type        = "ssh"
    host        = aws_lightsail_static_ip_attachment.attach-static-ip.ip_address
    user        = aws_lightsail_instance.instance.username
    private_key = file(var.ssh_private_key_file_path)
    timeout     = "10m"
  }

  provisioner "file" {
    source      = "setup.sh"
    destination = "/tmp/setup.sh"

    connection {
      type        = "ssh"
      host        = aws_lightsail_static_ip_attachment.attach-static-ip.ip_address
      user        = aws_lightsail_instance.instance.username
      private_key = file(var.ssh_private_key_file_path)
      timeout     = "10m"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup.sh",
      "/tmp/setup.sh > /tmp/setup.log"
    ]

    connection {
      type        = "ssh"
      host        = aws_lightsail_static_ip_attachment.attach-static-ip.ip_address
      user        = aws_lightsail_instance.instance.username
      private_key = file(var.ssh_private_key_file_path)
      timeout     = "10m"
    }
  }
}
