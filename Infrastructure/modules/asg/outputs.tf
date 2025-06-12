output "asg_name" {
  description = "Name der Auto Scaling Group"
  value       = aws_autoscaling_group.app_asg.name
}

output "launch_template_id" {
  description = "ID des Launch Templates"
  value       = aws_launch_template.app_lt.id
}

output "launch_template_version" {
  description = "Version des Launch Templates"
  value       = aws_launch_template.app_lt.latest_version
}