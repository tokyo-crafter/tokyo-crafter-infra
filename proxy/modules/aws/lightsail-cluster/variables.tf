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
