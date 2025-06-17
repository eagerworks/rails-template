
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
