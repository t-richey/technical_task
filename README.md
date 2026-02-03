# Victim Support Platform

**Note:** 
The code isn't full developed/tested. It is very much a 'concept' at the moment, although I have successfully deployed the Terraform code, and the services appear as expected when deployed on AWS.

## Overview

This projects aim is to provide a secure, cloud-based platform for victims of stalking and harassment to communicate with Police and Social Workers. The system uses open-source software and AWS Free Tier resources for testing.

## Architecture

### Components

- **Matrix Synapse**: Secure messaging server
- **Element Web**: Web-based chat client
- **Traccar**: GPS tracking
- **PostgreSQL RDS**: Database
- **Application Load Balancer**: Routing

## Prerequisites

- AWS Account (Free Tier eligible)
- Terraform >= 1.0
- AWS CLI configured with credentials

## Deployment Instructions

### 1. Clone and Setup
```bash
git clone https://github.com/t-richey/techinical_task
cd techinical_task
```

### 2. Configure Variables

Review and modify `variables.tf` if needed. Key variables:

- `aws_region`: AWS region (default: eu-west-2)
- `project_name`: Project name for resource naming
- `vpc_cidr`: VPC CIDR block (default: 10.0.0.0/16)
- `db_password`: Database password (change in production!)

### 3. Initialize Terraform
```bash
terraform init
```

### 4. Review the Plan
```bash
terraform plan
```

Expected output: ~56 resources to be created

### 5. Deploy Infrastructure
```bash
terraform apply
```

Type `yes` when prompted. Deployment takes **~10 minutes**.

### 6. Access the Platform

After deployment completes, Terraform will output:
```bash
load_balancer_url = "http://victim-support-alb-xxxxxxxxx.eu-west-2.elb.amazonaws.com"
```

Or, to manually fetch:

```bash
terraform output load_balancer_url
```

## Cleanup

To destroy all resources:
```bash
terraform destroy
```

Type `yes` when prompted. This will delete all infrastructure.

## Post-Deployment Cleanup

To avoid conflicts on re-deployment, delete the VPC Flow Log group created by Terraform:
```bash
aws logs delete-log-group --log-group-name /aws/vpc/victim-support-app-dev-flow-log
```

## Project Structure
```bash
.
├── README.md                          # This document
├── main.tf                            # Root orchestration
├── variables.tf                       # Configuration inputs  
├── outputs.tf                         # Deployment outputs
├── diagram.png                        # Network diagram
└── modules/
    ├── vpc/
    │   ├── main.tf                   # VPC, subnets, routing, NAT
    │   ├── variables.tf              # VPC inputs
    │   └── outputs.tf                # VPC outputs (IDs, CIDRs)
    ├── security-groups/
    │   ├── main.tf                   # All security group rules
    │   ├── variables.tf              # SG inputs  
    │   └── outputs.tf                # Security group IDs
    ├── database/
    │   ├── main.tf                   # RDS PostgreSQL
    │   ├── variables.tf              # DB configuration
    │   └── outputs.tf                # DB endpoint, name
    ├── compute/
    │   ├── main.tf                   # EC2 instances
    │   ├── variables.tf              # Instance configuration
    │   ├── outputs.tf                # Instance IPs
    │   ├── user_data_matrix.sh       # Matrix installation script
    │   ├── user_data_element.sh      # Element installation script
    │   └── user_data_traccar.sh      # Traccar installation script
    └── load-balancer/
        ├── main.tf                   # ALB, target groups, listeners
        ├── variables.tf              # LB configuration
        └── outputs.tf                # ALB DNS name
```







