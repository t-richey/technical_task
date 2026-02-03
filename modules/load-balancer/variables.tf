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

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID for ALB"
  type        = string
}

variable "matrix_instance_id" {
  description = "Matrix server instance ID"
  type        = string
}

variable "element_instance_id" {
  description = "Element server instance ID"
  type        = string
}

variable "traccar_instance_id" {
  description = "Traccar server instance ID"
  type        = string
}

variable "matrix_private_ip" {
  description = "Matrix server private IP"
  type        = string
}

variable "element_private_ip" {
  description = "Element server private IP"
  type        = string
}

variable "traccar_private_ip" {
  description = "Traccar server private IP"
  type        = string
}