# Terraform cloud
variable "tf_cloud_ip_ranges" {
  type        = list(string)
  description = "terraform cloud ip ranges"
}

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
variable "lightsail_instance_name" {
  type        = string
  description = "instance name of lightsail"
}

variable "lightsail_tag_group" {
  type        = string
  description = "group name"
}

variable "lightsail_instance_count" {
  type        = number
  default     = 1
  description = "instance count"
}

variable "lightsail_availability_zone" {
  type        = string
  default     = "ap-northeast-1a"
  description = "availability zone that lightsail located in"
}

variable "ssh_public_key" {
  type        = string
  description = "public key to install lightsail instance"
}

variable "ssh_private_key" {
  type        = string
  description = "private key to connect lightsail instance"
}
