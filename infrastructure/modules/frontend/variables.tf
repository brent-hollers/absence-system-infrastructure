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