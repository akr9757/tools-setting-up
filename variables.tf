variable "tools" {
  default = {
    sonarqube = {
      instance_type = "t3.medium"
      port          = 9000
      priority      = 100
    }
    prometheus = {
      instance_type = "t3.small"
      port          = 9090
      priority      = 101
    }
    elk = {
      instance_type = "m6in.large"
      port          = 80
      priority      = 102
    }
    alertmanager = {
      instance_type = "t3.small"
      port          = 9093
      priority      = 103
    }
    grafana = {
      instance_type = "t3.small"
      port          = 3000
      priority      = 104
    }
  }
}