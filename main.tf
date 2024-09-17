module "ec2" {
  source = "./modules/ec2"

  for_each = var.tools
  instance_type = each.value["instance_type"]
  tool_name     = each.key
}