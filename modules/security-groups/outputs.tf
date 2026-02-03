output "alb_sg_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb.id
}

output "matrix_sg_id" {
  description = "Matrix Synapse security group ID"
  value       = aws_security_group.matrix.id
}

output "element_sg_id" {
  description = "Element Web security group ID"
  value       = aws_security_group.element.id
}

output "traccar_sg_id" {
  description = "Traccar security group ID"
  value       = aws_security_group.traccar.id
}

output "rds_sg_id" {
  description = "RDS security group ID"
  value       = aws_security_group.rds.id
}

output "police_access_sg_id" {
  description = "Police access security group ID"
  value       = aws_security_group.police_access.id
}

output "social_worker_access_sg_id" {
  description = "Social worker access security group ID"
  value       = aws_security_group.social_worker_access.id
}

output "victim_access_sg_id" {
  description = "Victim access security group ID"
  value       = aws_security_group.victim_access.id
}