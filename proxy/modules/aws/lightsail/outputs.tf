## all of instance
output "instance" {
  value     = aws_lightsail_instance.instance
  sensitive = true
}

## ssh user name
output "ssh_user" {
  value = local.ssh_user
}
