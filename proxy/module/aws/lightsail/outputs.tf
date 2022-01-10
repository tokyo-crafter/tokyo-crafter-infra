## all of instance
output "instances" {
  value     = values(aws_lightsail_instance.instance)[*]
  sensitive = true
}
