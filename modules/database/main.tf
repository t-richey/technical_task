# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}

# RDS PostgreSQL Instance
resource "aws_db_instance" "postgresql" {
  identifier = "${var.project_name}-${var.environment}-postgres"

  # Engine
  engine         = "postgres"
  engine_version = null          # Use default version
  instance_class = "db.t3.micro" # Free tier

  # Storage
  allocated_storage     = 20 # Free tier: up to 20GB
  max_allocated_storage = 0  # Disabled autoscaling for free tier
  storage_type          = "gp2"
  storage_encrypted     = true

  # Database
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = 5432

  # Network & Security
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.database_security_group_id]
  publicly_accessible    = false

  # Backup & Maintenance
  backup_retention_period = 0    # Disabled backups for free tier (7 days)
  backup_window           = null # Disabled for free tier ("03:00-04:00")
  maintenance_window      = null # Disabled for free tier ("mon:04:00-mon:05:00")

  # High Availability (disabled for free tier)
  multi_az = false

  # Monitoring (Disabled for free tier)
  # enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  # monitoring_interval             = 60
  # monitoring_role_arn             = aws_iam_role.rds_monitoring.arn

  # Deletion protection (set to false for testing)
  deletion_protection = false
  skip_final_snapshot = true

  # Performance Insights (disabled for free tier)
  performance_insights_enabled = false

  tags = {
    name = "${var.project_name}-${var.environment}-postgresql"
  }
}

# IAM Role for RDS Enhanced Monitoring
resource "aws_iam_role" "rds_monitoring" {
  name = "${var.project_name}-${var.environment}-rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    name = "${var.project_name}-${var.environment}-rds-monitoring-role"
  }
}

resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}