variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "List of CIDR blocks for private application subnets"
  type        = list(string)
}

variable "private_db_subnet_cidrs" {
  description = "List of CIDR blocks for private database subnets"
  type        = list(string)
}