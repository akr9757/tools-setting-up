terraform {
  backend "s3" {
    bucket = "akrs-bucket"
    key    = "tools/terraform.statefile"
    region = "us-east-1"
  }
}