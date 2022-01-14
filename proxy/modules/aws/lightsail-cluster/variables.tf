# Lightsail
variable "instance_name_prefix" {
  type        = string
  description = "instance name of lightsail"
}

variable "tag_group" {
  type        = string
  description = "group name"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "instance_count" {
  type        = number
  default     = 1
  description = "instance count"
}

variable "ssh_public_key" {
  type        = string
  description = "public key to install lightsail instance"
}

variable "ssh_private_key" {
  type        = string
  description = "private key to connect lightsail instance"
}

variable "vpn_user" {
  type        = string
  description = "vpn user"
}

variable "vpn_password" {
  type        = string
  description = "vpn password"
}

variable "vpn_psk" {
  type        = string
  description = "Pre-Shared Key"
}

variable "vpn_target_ip" {
  type        = string
  description = "vpn target"
}
