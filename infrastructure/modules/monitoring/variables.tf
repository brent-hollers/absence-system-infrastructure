variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# EC2 Monitoring
variable "instance_id" {
  description = "EC2 instance ID to monitor"
  type        = string
}

# ALB Monitoring
variable "alb_arn" {
  description = "Full ALB ARN"
  type        = string
}

variable "alb_arn_suffix" {
  description = "ALB ARN suffix (for CloudWatch dimensions)"
  type        = string
}

# Target Group Monitoring
variable "target_group_arn" {
  description = "Full target group ARN"
  type        = string
}

variable "target_group_arn_suffix" {
  description = "Target group ARN suffix (for CloudWatch dimensions)"
  type        = string
}

# CloudFront Monitoring
variable "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  type        = string
}

# Alerting
variable "alert_email" {
  description = "Email address for alert notifications"
  type        = string
}