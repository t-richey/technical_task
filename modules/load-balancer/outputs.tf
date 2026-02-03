output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.main.dns_name
}

output "alb_arn" {
  description = "ARN of the load balancer"
  value       = aws_lb.main.arn
}

output "alb_zone_id" {
  description = "Zone ID of the load balancer"
  value       = aws_lb.main.zone_id
}

output "matrix_target_group_arn" {
  description = "ARN of Matrix target group"
  value       = aws_lb_target_group.matrix.arn
}

output "element_target_group_arn" {
  description = "ARN of Element target group"
  value       = aws_lb_target_group.element.arn
}

output "traccar_target_group_arn" {
  description = "ARN of Traccar target group"
  value       = aws_lb_target_group.traccar.arn
}