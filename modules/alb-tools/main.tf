resource "aws_lb" "tools" {
  name               = local.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main.id]
  subnets            = data.aws_subnets.subnets.ids


  tags = {
    Environment = local.name
  }
}

resource "aws_security_group" "main" {
  name        = "${ local.name }-sg"
  description = "${ local.name }-sg"
  vpc_id      = "vpc-016b04b871ea2362c"


  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "HTTP"
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "HTTPS"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${ local.name }-sg"
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.tools.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404 page not found"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.tools.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}