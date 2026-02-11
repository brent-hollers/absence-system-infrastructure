# modules/load_balancer/variables.tf

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID for ALB"
  type        = string
}

variable "instance_id" {
  description = "EC2 instance ID to target"
  type        = string
}

variable "instance_port" {
  description = "Port where application listens"
  type        = number
  default     = 5678
}