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

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = "absences.smaschool.org"
}

variable "enable_https" {
  description = "Enable HTTPS with ACM certificate"
  type        = bool
  default     = true
}

variable "alert_email" {
  description = "Email address for CloudWatch alarms"
  type        = string
  default     = "bhollers@smaschool.org"
}

variable "github_org" {
  description = "GitHub organization or username"
  type        = string
  default     = "brent-hollers"  # Your GitHub username
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "absence-system-infrastructure"
}