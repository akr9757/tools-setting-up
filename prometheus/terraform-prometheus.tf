terraform {
  backend "s3" {
    bucket = "akr9757"
    key    = "prometheus/terraform.statefile"
    region = "us-east-1"
  }
}

data "aws_ami" "ami" {
  most_recent = true
  owners = ["973714476881"]
  name_regex = "Centos-8-DevOps-Practice"
}

resource "aws_instance" "prometheus" {
  ami           = data.aws_ami.ami.image_id
  instance_type = "t3.small"
  vpc_security_group_ids = ["sg-06d14744e7a12dcaf"]
  iam_instance_profile = aws_iam_instance_profile.main.name

  tags = {
    Name = "prometheus"
  }
}

resource "aws_route53_record" "private" {
  zone_id = "Z04275581JIKR4XEVM94K"
  name    = "prometheus-pvt"
  type    = "CNAME"
  ttl     = 30
  records = [aws_instance.prometheus.private_ip]
}

resource "aws_route53_record" "public" {
  zone_id = "Z04275581JIKR4XEVM94K"
  name    = "prometheus-pub"
  type    = "A"
  ttl     = 30
  records = [aws_instance.prometheus.public_ip]
}

resource "aws_route53_record" "grafana" {
  zone_id = "Z04275581JIKR4XEVM94K"
  name    = "grafana"
  type    = "A"
  ttl     = 30
  records = [aws_instance.prometheus.public_ip]
}

resource "aws_iam_instance_profile" "main" {
  name = "prometheus-profile"
  role = aws_iam_role.main.name
}

resource "aws_iam_role" "main" {
  name               = "prometheus-role"

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

  inline_policy {
    name = "parameter-store"

    policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "VisualEditor0",
          "Effect": "Allow",
          "Action": [
            "ec2:DescribeInstances",
            "ec2:DescribeAvailabilityZones"
          ],
          "Resource": "*"
        }
      ]
    })
  }
}