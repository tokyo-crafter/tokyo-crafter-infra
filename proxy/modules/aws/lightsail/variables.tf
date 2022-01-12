# Lightsail
variable "instance_name" {
  type        = string
  description = "instance name of lightsail"
}

variable "tag_group" {
  type        = string
  description = "group name"
}

variable "key_pair_name" {
  type        = string
  description = "key pair name applying to lightsail instance"
}

variable "availability_zone" {
  type        = string
  description = "availability zone that lightsail located in"
}

variable "ssh_private_key_file_name" {
  type        = string
  description = "private key file name"
}
