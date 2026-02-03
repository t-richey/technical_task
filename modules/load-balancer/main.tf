# Application Load Balancer
resource "aws_lb" "main" {
  name               = "${var.project_name}-${var.environment}-alb"
  internal           = false # Internet-facing
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection       = false
  enable_http2                     = true
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "${var.project_name}-${var.environment}-alb"
  }
}

# Target Group for Matrix Synapse
resource "aws_lb_target_group" "matrix" {
  name     = "${var.project_name}-matrix-tg"
  port     = 8008
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/_matrix/client/versions"
    matcher             = "200"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-matrix-tg"
  }
}

# Target Group for Element Web
resource "aws_lb_target_group" "element" {
  name     = "${var.project_name}-element-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    matcher             = "200"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-element-tg"
  }
}

# Target Group for Traccar
resource "aws_lb_target_group" "traccar" {
  name     = "${var.project_name}-traccar-tg"
  port     = 8082
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/api/server"
    matcher             = "200"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-traccar-tg"
  }
}

# Attach Traccar instance to target group
resource "aws_lb_target_group_attachment" "traccar" {
  target_group_arn = aws_lb_target_group.traccar.arn
  target_id        = var.traccar_instance_id
  port             = 8082
}

# Attach Matrix instance to target group
resource "aws_lb_target_group_attachment" "matrix" {
  target_group_arn = aws_lb_target_group.matrix.arn
  target_id        = var.matrix_instance_id
  port             = 8008
}

# Attach Element instance to target group
resource "aws_lb_target_group_attachment" "element" {
  target_group_arn = aws_lb_target_group.element.arn
  target_id        = var.element_instance_id
  port             = 80
}

# HTTP Listener (Port 80)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Victim Support Platform - Access Denied"
      status_code  = "403"
    }
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-http-listener"
  }
}

# Listener Rules for path-based routing

# Route /matrix/* to Matrix Synapse
resource "aws_lb_listener_rule" "matrix" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.matrix.arn
  }

  condition {
    path_pattern {
      values = ["/_matrix/*", "/_synapse/*"]
    }
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-matrix-rule"
  }
}

# Route /tracking/* to Traccar
resource "aws_lb_listener_rule" "traccar" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.traccar.arn
  }

  condition {
    path_pattern {
      values = ["/tracking/*", "/health"]
    }
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-traccar-rule"
  }
}

# Route /* to Element Web (default app)
resource "aws_lb_listener_rule" "element" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 300

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.element.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-element-rule"
  }
}