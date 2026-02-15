output "certificate_arn" {
  description = "ACM certificate ARN"
  value       = data.aws_acm_certificate.main.arn
}

output "domain_name" {
  description = "Domain name"
  value       = var.domain_name
}