resource "aws_instance" "tools" {
  ami           = data.aws_ami.ami.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = ["sg-06d14744e7a12dcaf"]
  subnet_id = "subnet-07f210c8b4539423c"
  iam_instance_profile = aws_iam_instance_profile.main.name

  instance_market_options {
    market_type   = "spot"
    spot_options {
      instance_interruption_behavior = "stop"
      spot_instance_type             = "persistent"
    }
  }

  tags = {
    Name = var.tool_name
  }
}

resource "aws_route53_record" "tools" {
  zone_id = "Z04275581JIKR4XEVM94K"
  name    = var.tool_name
  type    = "CNAME"
  ttl     = 30
  records = [var.dns_name]
}

# resource "aws_route53_record" "internal" {
#   zone_id = "Z04275581JIKR4XEVM94K"
#   name    = "elk-pub"
#   type    = "A"
#   ttl     = 30
#   records = [aws_instance.tools.private_ip]
# }

resource "aws_lb_listener_rule" "main" {
  listener_arn = var.listener_arn
  priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  condition {
    path_pattern {
      values = ["${var.tool_name}.akrdevops.online"]
    }
  }
}

resource "aws_lb_target_group" "main" {
  name     = "${var.tool_name}-tg"
  port     = var.port
  protocol = "HTTP"
  vpc_id   = "vpc-016b04b871ea2362c"
}

resource "aws_lb_target_group_attachment" "main" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.tools.id
  port             = var.port
}

resource "aws_iam_instance_profile" "main" {
  name = "${var.tool_name}-profile"
  role = aws_iam_role.main.name
}

resource "aws_iam_role" "main" {
  name               = "${var.tool_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "policy" {
  name        = "${var.tool_name}-policy"
  path        = "/"
  description = "${var.tool_name}-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = var.policy_list
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.main.arn
  policy_arn = aws_iam_policy.policy.arn
}