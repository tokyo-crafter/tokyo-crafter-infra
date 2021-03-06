variable "group_name" {
  type = string
}

variable "aws_access_key_id" {
  type        = string
  description = "AWS_ACCESS_KEY_ID"
}

variable "aws_secret_access_key" {
  type        = string
  description = "AWS_SECRET_ACCESS_KEY"
}

variable "ssh_public_key" {
  type        = string
  description = "public key to install lightsail instance"
}

variable "ssh_private_key" {
  type        = string
  description = "private key to connect lightsail instance"
}
