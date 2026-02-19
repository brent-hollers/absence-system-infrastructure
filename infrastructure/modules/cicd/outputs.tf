output "github_actions_role_arn" {
  description = "ARN of IAM role for GitHub Actions"
  value       = aws_iam_role.github_actions.arn
}

output "oidc_provider_arn" {
  description = "ARN of GitHub OIDC provider"
  value       = aws_iam_openid_connect_provider.github.arn
}

output "deployment_instructions" {
  description = "Instructions for configuring GitHub Actions"
  value = <<-EOT
    
    GitHub Actions Configuration:
    ============================
    
    Add this to your GitHub Actions workflow:
    
    permissions:
      id-token: write
      contents: read
    
    - name: Configure AWS Credentials
      uses: aws-actions/configure-aws-credentials@v4
      with:
        role-to-assume: ${aws_iam_role.github_actions.arn}
        aws-region: us-east-1
    
    Repository: ${var.github_org}/${var.github_repo}
    Allowed branches: ${join(", ", var.allowed_branches)}
  EOT
}