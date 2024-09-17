module "ec2" {
  source = "./modules/ec2"

  for_each      = var.tools
  instance_type = each.value["instance_type"]
  tool_name     = each.key

  dns_name     = module.alb-tools.dns_name
  listener_arn = module.alb-tools.listener

  port     = each.value["port"]
  priority = each.value["priority"]
}

module "alb-tools" {
  source = "./modules/alb-tools"
}