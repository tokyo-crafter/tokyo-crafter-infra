output "proxy_public_ips" {
  value = module.lightsail-cluster.public_ips
  sensitive = true
}

output "ssh_user" {
  value = module.lightsail-cluster.ssh_user
  sensitive = true
}
