# modules/compute/main.tf

# IAM Role for EC2
resource "aws_iam_role" "ec2" {
  name = "${var.project_name}-ec2-role"

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
    Name = "${var.project_name}-ec2-role"
  }
}

# Attach SSM policy for Systems Manager access
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Attach CloudWatch policy for logging/monitoring
resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Instance Profile (connects IAM role to EC2)
resource "aws_iam_instance_profile" "ec2" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2.name

  tags = {
    Name = "${var.project_name}-ec2-profile"
  }
}

# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 Instance
resource "aws_instance" "n8n" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = aws_iam_instance_profile.ec2.name

  user_data = <<-EOF
            #!/bin/bash
            yum update -y
            
            amazon-linux-extras install docker -y
            systemctl start docker
            systemctl enable docker
            usermod -a -G docker ec2-user
            
            # Run n8n with proper configuration
            docker run -d \
              --name n8n \
              -p 5678:5678 \
              ${var.enable_https && var.n8n_domain != "" ? "-e N8N_PROTOCOL=https" : ""} \
              ${var.n8n_domain != "" ? "-e N8N_HOST=${var.n8n_domain}" : ""} \
              ${var.n8n_domain != "" ? "-e WEBHOOK_URL=https://${var.n8n_domain}" : ""} \
              --restart unless-stopped \
              n8nio/n8n
            EOF

  tags = {
    Name = "${var.project_name}-n8n-server"
  }
}