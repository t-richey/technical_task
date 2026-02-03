output "db_instance_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.postgresql.endpoint
}

output "db_instance_address" {
  description = "RDS instance address"
  value       = aws_db_instance.postgresql.address
}

output "db_instance_name" {
  description = "RDS database name"
  value       = aws_db_instance.postgresql.db_name
}

output "db_instance_port" {
  description = "RDS instance port"
  value       = aws_db_instance.postgresql.port
}

output "db_instance_id" {
  description = "RDS instance ID"
  value       = aws_db_instance.postgresql.id
}