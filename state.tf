terraform {
  backend "s3" {
    bucket = "akr9757"
    key    = "tools/terraform.statefile"
    region = "us-east-1"
  }
}