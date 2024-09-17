variable "tools" {
  default = {
    sonarqube = {
      instance_type = "t3.small"
      port          = 9000
    }
    prometheus = {
      instance_type = "t3.small"
      port          = 9090
    }
    elk = {
      instance_type = "m6in.large"
      port          = 80
    }
    alert_manager = {
      instance_type = "t3.small"
      port          = 9093
    }
    grafana = {
      instance_type = "m6in.large"
      port          = 3000
    }
  }
}