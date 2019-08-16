terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  profile = "default"
  region  = var.region
  version = "~> 2.23"
}

output "load_balancer" {
  value = aws_lb.spring_boot_service_lb.dns_name
}
