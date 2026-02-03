output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "Private application subnet IDs"
  value       = module.vpc.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "Private database subnet IDs"
  value       = module.vpc.private_db_subnet_ids
}

output "database_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = module.database.db_instance_endpoint
  sensitive   = true
}

output "matrix_server_ip" {
  description = "Matrix server private IP"
  value       = module.compute.matrix_private_ip
}

output "element_server_ip" {
  description = "Element server private IP"
  value       = module.compute.element_private_ip
}

output "traccar_server_ip" {
  description = "Traccar server private IP"
  value       = module.compute.traccar_private_ip
}

output "load_balancer_url" {
  description = "URL to access the platform"
  value       = "http://${module.load_balancer.alb_dns_name}"
}