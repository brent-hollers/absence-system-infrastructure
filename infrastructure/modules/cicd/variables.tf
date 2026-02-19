variable "project_name" {
  description = "Project name"
  type        = string
}

variable "github_org" {
  description = "GitHub organization or username"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name for frontend deployment"
  type        = string
}

variable "cloudfront_distribution_id" {
  description = "CloudFront distribution ID for cache invalidation"
  type        = string
}

variable "allowed_branches" {
  description = "Git branches allowed to deploy"
  type        = list(string)
  default     = ["main"]
}