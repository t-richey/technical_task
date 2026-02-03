variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for EC2 instances"
  type        = list(string)
}

variable "matrix_security_group_id" {
  description = "Security group ID for Matrix server"
  type        = string
}

variable "element_security_group_id" {
  description = "Security group ID for Element server"
  type        = string
}

variable "traccar_security_group_id" {
  description = "Security group ID for Traccar server"
  type        = string
}

variable "db_endpoint" {
  description = "RDS database endpoint"
  type        = string
}

variable "db_name" {
  description = "RDS database name"
  type        = string
}

variable "db_password" {
  description = "RDS database password"
  type        = string
  sensitive   = true
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro" # Free tier eligible
}