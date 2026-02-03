terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      ManagedBy   = "Terraform"
      Environment = var.environment
    }
  }
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones

  public_subnet_cidrs      = ["10.0.1.0/24", "10.0.2.0/24"]
  private_app_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  private_db_subnet_cidrs  = ["10.0.21.0/24", "10.0.22.0/24"]
}

# Security Groups Module
module "security_groups" {
  source = "./modules/security-groups"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
}

# Database Module
module "database" {
  source = "./modules/database"

  project_name               = var.project_name
  environment                = var.environment
  vpc_id                     = module.vpc.vpc_id
  private_subnet_ids         = module.vpc.private_db_subnet_ids
  database_security_group_id = module.security_groups.rds_sg_id
  db_password                = var.db_password
}

# Compute Module
module "compute" {
  source = "./modules/compute"

  project_name              = var.project_name
  environment               = var.environment
  vpc_id                    = module.vpc.vpc_id
  private_subnet_ids        = module.vpc.private_app_subnet_ids
  matrix_security_group_id  = module.security_groups.matrix_sg_id
  element_security_group_id = module.security_groups.element_sg_id
  traccar_security_group_id = module.security_groups.traccar_sg_id
  db_endpoint               = module.database.db_instance_address
  db_name                   = module.database.db_instance_name
  db_password               = var.db_password
}

# Load Balancer Module
module "load_balancer" {
  source = "./modules/load-balancer"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.security_groups.alb_sg_id

  matrix_instance_id  = module.compute.matrix_instance_id
  element_instance_id = module.compute.element_instance_id
  traccar_instance_id = module.compute.traccar_instance_id

  matrix_private_ip  = module.compute.matrix_private_ip
  element_private_ip = module.compute.element_private_ip
  traccar_private_ip = module.compute.traccar_private_ip
}


