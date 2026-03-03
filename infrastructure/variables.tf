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
  default     = "brent-hollers" # Your GitHub username
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "absence-system-infrastructure"
}

variable "frontend_domain" {
  description = "Custom domain for frontend form"
  type        = string
  default     = "form.absences.smaschool.org"
}

variable "frontend_certificate_arn" {
  description = "ACM certificate ARN for frontend domain"
  type        = string
  default     = "arn:aws:acm:us-east-1:005608856189:certificate/7a2c2b6e-69f8-4d60-b72f-afb462262b2f"
}