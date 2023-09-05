data "aws_vpc" "app_config_spike" {
  filter {
    name   = "tag:Name"
    values = ["root-deploy-testing"]
  }
  filter {
    name   = "tag:Environment"
    values = ["deploy-testing"]
  }
}

data "aws_subnets" "app_config_spike" {
  filter {
    name   = "tag:Name"
    values = ["root-deploy-testing"]
  }
  filter {
    name   = "tag:Environment"
    values = ["deploy-testing"]
  }
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "tag:Name"
    values = ["root-deploy-testing"]
  }
  filter {
    name   = "tag:Environment"
    values = ["deploy-testing"]
  }
  filter {
    name   = "tag:Type"
    values = ["public"]
  }
}

data "aws_security_groups" "app_config_spike" {
  filter {
    name   = "tag:Name"
    values = ["root-deploy-testing"]
  }
  filter {
    name   = "tag:Environment"
    values = ["deploy-testing"]
  }
}

data "aws_security_groups" "lb_ingress" {
  filter {
    name   = "tag:Name"
    values = ["root-deploy-testing-load-balancer"]
  }
  filter {
    name   = "tag:Environment"
    values = ["deploy-testing"]
  }
}
