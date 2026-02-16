output "sns_topic_arn" {
  description = "ARN of SNS topic for alerts"
  value       = aws_sns_topic.alerts.arn
}

output "ec2_alarm_arn" {
  description = "ARN of EC2 health alarm"
  value       = aws_cloudwatch_metric_alarm.ec2_status_check.arn
}

output "alb_unhealthy_alarm_arn" {
  description = "ARN of ALB unhealthy targets alarm"
  value       = aws_cloudwatch_metric_alarm.alb_unhealthy_targets.arn
}

output "response_time_alarm_arn" {
  description = "ARN of response time SLO alarm"
  value       = aws_cloudwatch_metric_alarm.alb_response_time_slo.arn
}