output "proxy_public_ips" {
  value = module.lightsail-cluster.public_ips
}

output "ssh_user" {
  value = module.lightsail-cluster.ssh_user
}
