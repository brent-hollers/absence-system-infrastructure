# modules/frontend/variables.tf

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of the ALB (for form submission)"
  type        = string
  default     = ""
}

variable "custom_domain" {
  description = "Custom domain for CloudFront"
  type        = string
  default     = ""
}

variable "certificate_arn" {
  description = "ACM certificate ARN for custom domain"
  type        = string
  default     = ""
}