# modules/compute/outputs.tf

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.n8n.id
}

output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.n8n.private_ip
}

output "instance_arn" {
  description = "ARN of the EC2 instance"
  value       = aws_instance.n8n.arn
}