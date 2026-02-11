# infrastructure/variables.tf

variable "project_name" {
  description = "Project name used for all resources"
  type        = string
  default     = "absence-system"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}