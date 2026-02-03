output "matrix_instance_id" {
  description = "Matrix server instance ID"
  value       = aws_instance.matrix.id
}

output "matrix_private_ip" {
  description = "Matrix server private IP"
  value       = aws_instance.matrix.private_ip
}

output "element_instance_id" {
  description = "Element server instance ID"
  value       = aws_instance.element.id
}

output "element_private_ip" {
  description = "Element server private IP"
  value       = aws_instance.element.private_ip
}

output "traccar_instance_id" {
  description = "Traccar server instance ID"
  value       = aws_instance.traccar.id
}

output "traccar_private_ip" {
  description = "Traccar server private IP"
  value       = aws_instance.traccar.private_ip
}