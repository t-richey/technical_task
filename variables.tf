variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "victim-support-app"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16" # Industy standard for small VPCs
}

variable "availability_zones" {
  description = "List of availability zones to use for subnets"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b"]
}

variable "db_password" {
  description = "Master password for RDS PostgreSQL"
  type        = string
  sensitive   = true                     # Avoid logging
  default     = "VerySecurePassword123!" # Use AWS Secrets Manager in production
}