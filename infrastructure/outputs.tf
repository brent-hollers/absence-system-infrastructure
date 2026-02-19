# infrastructure/outputs.tf

# Networking Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

# Compute Outputs
output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = module.compute.instance_id
}

output "ec2_private_ip" {
  description = "EC2 private IP"
  value       = module.compute.private_ip
}

# Load Balancer Outputs
output "alb_dns_name" {
  description = "ALB DNS name - use this to access n8n"
  value       = module.load_balancer.alb_dns_name
}

output "alb_url" {
  description = "Full URL to access n8n via ALB"
  value       = "http://${module.load_balancer.alb_dns_name}"
}

# Frontend Outputs
output "cloudfront_url" {
  description = "CloudFront URL for the form"
  value       = module.frontend.cloudfront_url
}

output "s3_bucket_name" {
  description = "S3 bucket for frontend"
  value       = module.frontend.bucket_name
}

# Quick Access Summary
output "access_urls" {
  description = "Quick reference for accessing the system"
  value = {
    n8n_via_alb     = "http://${module.load_balancer.alb_dns_name}"
    form_cloudfront = module.frontend.cloudfront_url
  }
}

output "application_url" {
  description = "URL to access the application"
  value       = var.enable_https ? "https://${var.domain_name}" : "http://${module.load_balancer.alb_dns_name}"
}

output "n8n_url" {
  description = "URL to access n8n"
  value       = var.enable_https ? "https://${var.domain_name}" : "http://${module.load_balancer.alb_dns_name}"
}

output "github_actions_role_arn" {
  description = "IAM role ARN for GitHub Actions"
  value       = module.cicd.github_actions_role_arn
}

output "cicd_setup_instructions" {
  description = "Instructions for setting up GitHub Actions"
  value       = module.cicd.deployment_instructions
}