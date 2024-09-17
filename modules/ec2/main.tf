terraform {
  backend "s3" {
    bucket = "akr9757"
    key    = "tools/terraform.statefile"
    region = "us-east-1"
  }
}



resource "aws_instance" "tools" {
  ami           = data.aws_ami.ami.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = ["sg-06d14744e7a12dcaf"]
  subnet_id = "subnet-07f210c8b4539423c"
  #   iam_instance_profile = aws_iam_instance_profile.main.name

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
  records = [aws_instance.tools.public_ip]
}

resource "aws_route53_record" "internal"{
  zone_id = "Z04275581JIKR4XEVM94K"
  name    = "elk-pub"
  type    = "A"
  ttl     = 30
  records = [aws_instance.elk.public_ip]