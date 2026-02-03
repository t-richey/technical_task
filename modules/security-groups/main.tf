# Application Load Balancer Security Group
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from internet (redirect to HTTPS)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-alb-sg"
  }
}

# Matrix Synapse Server Security Group
resource "aws_security_group" "matrix" {
  name        = "${var.project_name}-${var.environment}-matrix-sg"
  description = "Security group for Matrix Synapse server"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Matrix federation port from ALB"
    from_port       = 8448
    to_port         = 8448
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    description     = "Matrix client API from ALB"
    from_port       = 8008
    to_port         = 8008
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-matrix-sg"
  }
}

# Element Web Server Security Group
resource "aws_security_group" "element" {
  name        = "${var.project_name}-${var.environment}-element-sg"
  description = "Security group for Element Web server"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-element-sg"
  }
}

# Traccar Server Security Group
resource "aws_security_group" "traccar" {
  name        = "${var.project_name}-${var.environment}-traccar-sg"
  description = "Security group for Traccar GPS tracking server"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Traccar web interface from ALB"
    from_port       = 8082
    to_port         = 8082
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    description = "GPS devices TCP (multiple protocols)"
    from_port   = 5000
    to_port     = 5150
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "GPS devices UDP (multiple protocols)"
    from_port   = 5000
    to_port     = 5150
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-traccar-sg"
  }
}

# RDS PostgreSQL Security Group
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "Security group for RDS PostgreSQL database"
  vpc_id      = var.vpc_id

  ingress {
    description     = "PostgreSQL from Matrix server"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.matrix.id]
  }

  ingress {
    description     = "PostgreSQL from Traccar server"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.traccar.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-rds-sg"
  }
}

# User-specific Security Groups for additional segmentation
# Placeholder for future user role-based security groups

# Police Users
resource "aws_security_group" "police_access" {
  name        = "${var.project_name}-${var.environment}-police-access-sg"
  description = "Additional security controls for police user access"
  vpc_id      = var.vpc_id

  tags = {
    Name     = "${var.project_name}-${var.environment}-police-access-sg"
    UserType = "Police"
  }
}

# Social Worker Users
resource "aws_security_group" "social_worker_access" {
  name        = "${var.project_name}-${var.environment}-social-worker-access-sg"
  description = "Additional security controls for social worker access"
  vpc_id      = var.vpc_id

  tags = {
    Name     = "${var.project_name}-${var.environment}-social-worker-access-sg"
    UserType = "SocialWorker"
  }
}

# Victim Users
resource "aws_security_group" "victim_access" {
  name        = "${var.project_name}-${var.environment}-victim-access-sg"
  description = "Additional security controls for victim access"
  vpc_id      = var.vpc_id

  tags = {
    Name     = "${var.project_name}-${var.environment}-victim-access-sg"
    UserType = "Victim"
  }
}