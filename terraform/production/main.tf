terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  profile = var.aws_profile
  region  = var.region
}

module "infrastructure" {
  source = "../modules/eager-infrastructure/module"

  region        = var.region
  deployer_key  = var.deployer_key
  app_name      = var.app_name
  app_secrets   = var.app_secrets
  db_password   = var.db_password
  dns_name      = var.dns_name
  site_url      = var.site_url
  servers_count = var.servers_count
  aws_profile   = var.aws_profile
}

# ===== Variables =====

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "deployer_key" {
  description = "SSH public key path for the deployer"
  type        = string
}

variable "app_name" {
  description = "Name of the application. This will be used for naming resources."
  type        = string
}

variable "app_secrets" {
  description = "Secrets for your app"
  type        = map(string)
  default     = {}
}

variable "db_password" {
  description = "Password for the database user"
  type        = string
  sensitive   = true
}

variable "dns_name" {
  description = "DNS name for the application"
  type        = string
}

variable "site_url" {
  description = "Site URL for the application"
  type        = string
}

variable "aws_profile" {
  description = "AWS profile to use for the deployment"
  type        = string
}

variable "servers_count" {
  description = "Number of web servers to deploy"
  type        = number
  default     = 1
}

# ===== Outputs =====

output "web_servers_ip_addr" {
  value = module.infrastructure.web_servers_ip_addr
}

output "bastion_ip_addr" {
  value = module.infrastructure.bastion_ip_addr
}

output "container_registry_url" {
  value = module.infrastructure.container_registry_url
}
