resource "aws_ecs_service" "app_config_spike" {
  name            = "rails-ecs-app-config-spike"
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.app_config_spike.arn
  desired_count   = 1
  cluster         = aws_ecs_cluster.app_config_spike.id

  network_configuration {
    assign_public_ip = true
    subnets          = data.aws_subnets.app_config_spike.ids
    security_groups  = data.aws_security_groups.app_config_spike.ids
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_config_spike.arn
    container_name   = "rails-ecs-app-config-spike"
    container_port   = 3000
  }
}

resource "aws_cloudwatch_log_group" "app_config_spike" {
  name              = "/ecs/rails-ecs-app-config-spike"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "app_config_spike" {
  execution_role_arn       = aws_iam_role.app_config_spike_task_execution.arn
  family                   = "rails-ecs-app-config-spike"
  container_definitions    = <<EOF
[{
  "name": "rails-ecs-app-config-spike",
  "image": "${aws_ecr_repository.rails_app.repository_url}:latest",
  "portMappings": [{
    "containerPort": 3000
  }],
  "logConfiguration": {
    "logDriver": "awslogs",
    "options": {
      "awslogs-group": "/ecs/rails-ecs-app-config-spike",
      "awslogs-region": "us-east-1",
      "awslogs-stream-prefix": "ecs"
    }
  }
}
]
EOF
  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
}

resource "aws_iam_role" "app_config_spike_task_execution" {
  name               = "rails-ecs-app-config-spike-task-execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "ecs_task_execution_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  policy_arn = data.aws_iam_policy.ecs_task_execution_role.arn
  role       = aws_iam_role.app_config_spike_task_execution.name
}

resource "aws_ecs_cluster" "app_config_spike" {
  name = "rails-ecs-app-config-spike"
}

resource "aws_lb_target_group" "app_config_spike" {
  name        = "rails-ecs-app-config-spike"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.app_config_spike.id

  health_check {
    enabled = true
    path    = "/"
  }

  depends_on = [aws_alb.app_config_spike]
}

resource "aws_alb" "app_config_spike" {
  name               = "rails-ecs-app-config-spike"
  internal           = false
  load_balancer_type = "application"
  security_groups    = data.aws_security_groups.lb_ingress.ids
  subnets            = data.aws_subnets.public_subnets.ids
}

resource "aws_alb_listener" "app_config_http" {
  load_balancer_arn = aws_alb.app_config_spike.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.app_config_spike.arn
    type             = "forward"
  }
}

output "alb_url" {
  value = "http://${aws_alb.app_config_spike.dns_name}"
}