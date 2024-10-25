data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = ["vpc-0bc560bb2bad1c776"]
  }
}