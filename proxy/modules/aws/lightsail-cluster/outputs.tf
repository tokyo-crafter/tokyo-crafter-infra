## public ips
output "public_ips" {
  value     = values(module.lightsail)[*].instance["public_ip_address"]
  sensitive = true
}

## SSH user
output "ssh_user" {
  value     = length(values(module.lightsail)) > 0 ? values(module.lightsail)[0].ssh_user : ""
  sensitive = true
}
