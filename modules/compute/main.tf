# Get latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# IAM Role for EC2 instances
resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-${var.environment}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2-role"
  }
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-${var.environment}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# Attach SSM policy for Systems Manager access
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Matrix Synapse Server
resource "aws_instance" "matrix" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = [var.matrix_security_group_id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = true
    encrypted             = true
  }

  user_data = base64encode(templatefile("${path.module}/user_data_matrix.sh", {
    db_endpoint = var.db_endpoint
    db_name     = var.db_name
    db_password = var.db_password
  }))

  tags = {
    Name        = "${var.project_name}-${var.environment}-matrix-server"
    Application = "Matrix-Synapse"
  }
}

# Element Web Server
resource "aws_instance" "element" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[1]
  vpc_security_group_ids = [var.element_security_group_id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 10
    delete_on_termination = true
    encrypted             = true
  }

  user_data = base64encode(templatefile("${path.module}/user_data_element.sh", {
    matrix_server_ip = aws_instance.matrix.private_ip
  }))

  tags = {
    Name        = "${var.project_name}-${var.environment}-element-server"
    Application = "Element-Web"
  }

  depends_on = [aws_instance.matrix]
}

# Traccar Tracking Server
resource "aws_instance" "traccar" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = [var.traccar_security_group_id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 15
    delete_on_termination = true
    encrypted             = true
  }

  user_data = base64encode(templatefile("${path.module}/user_data_traccar.sh", {
    db_endpoint = var.db_endpoint
    db_name     = var.db_name
    db_password = var.db_password
  }))

  tags = {
    Name        = "${var.project_name}-${var.environment}-traccar-server"
    Application = "Traccar"
  }
}