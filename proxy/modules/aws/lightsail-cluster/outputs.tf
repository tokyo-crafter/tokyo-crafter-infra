## public ips
output "public_ips" {
  value     = values(module.lightsail)[*].instance["public_ip_address"]
}

## SSH user
output "ssh_user" {
  value     = values(module.lightsail)[0].ssh_user
}
