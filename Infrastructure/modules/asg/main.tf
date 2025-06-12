resource "aws_launch_template" "app_lt" {
  name_prefix   = "app-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = var.ec2_sg_ids
  }

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  user_data = base64encode(var.user_data)
}

resource "aws_autoscaling_group" "app_asg" {
  name                      = "app-asg"
  desired_capacity          = 2
  max_size                  = 4
  min_size                  = 1
  vpc_zone_identifier       = var.public_subnets
  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }
  target_group_arns = [var.target_group_arn]

  tag {
    key                 = "Name"
    value               = "AppInstance"
    propagate_at_launch = true
  }
}