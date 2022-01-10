terraform {
  required_providers {
    http = "~> 1.2"
  }
}

data "http" "terraform_cloud_ip_ranges" {
  url = "https://app.terraform.io/api/meta/ip-ranges"

  request_headers = {
    # Enabling the `If-Modified-Since` flag may result in an empty response
    # If-Modified-Since = "Tue, 26 May 2020 15:10:05 GMT"
    Accept = "application/json"
  }
}

locals {
  # assign JSONified output to a local variable
  terraform_cloud_ip_ranges = jsondecode(data.http.terraform_cloud_ip_ranges.body)
}

output "terraform_cloud_api_ip_ranges" {
  description = "Terraform Cloud API IP Ranges as JSON"
  value       = local.terraform_cloud_ip_ranges["api"]
}

output "terraform_cloud_notifications_ip_ranges" {
  description = "Terraform Cloud Notifications IP Ranges as JSON"
  value       = local.terraform_cloud_ip_ranges["notifications"]
}

output "terraform_cloud_sentinel_ip_ranges" {
  description = "Terraform Cloud Sentinel Runner IP Ranges as JSON"
  value       = local.terraform_cloud_ip_ranges["sentinel"]
}

output "terraform_cloud_ip_ranges" {
  description = "Terraform Cloud VCS Integration IP Ranges as JSON"
  value       = local.terraform_cloud_ip_ranges["vcs"]
}
