# AWS
variable "aws_access_key_id" {
  type        = string
  description = "AWS_ACCESS_KEY_ID"
}

variable "aws_secret_access_key" {
  type        = string
  description = "AWS_SECRET_ACCESS_KEY"
}

# Lightsail
variable "instance_name_prefix" {
  type        = string
  description = "instance name of lightsail"
}

variable "tag_group" {
  type        = string
  description = "group name"
}

variable "lightsail_instance_count" {
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
