## ECS

resource "aws_cloudwatch_log_group" "container_log_group" {
  name = "/fargate/service/${var.application_name}-${var.environment}"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_stream" "app" {
  log_group_name = aws_cloudwatch_log_group.container_log_group.name
  name = "ecs/spring-boot-service-dev"
}

resource "aws_ecs_task_definition" "app" {
  family = "${var.application_name}-${var.environment}"
  execution_role_arn = var.task_execution_role_arn
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = var.fargate_cpu
  memory = var.fargate_memory

  container_definitions = <<DEFINITION
[
  {
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.container_log_group.name}",
        "awslogs-region": "${var.region}",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "portMappings": [
      {
        "hostPort": ${var.container_port},
        "protocol": "tcp",
        "containerPort": ${var.container_port}
      }
    ],
    "image": "${var.container_image_uri}",
    "name": "${var.application_name}-${var.environment}",
    "cpu" : ${var.fargate_cpu},
    "memory": ${var.fargate_memory}
  }
]
DEFINITION

  tags = var.tags
}

resource "aws_ecs_cluster" "fargate_cluster" {
  name = "${var.application_name}-${var.environment}"
  tags = var.tags
}

resource "aws_ecs_service" "ecs_service" {
  name = "${var.application_name}-${var.environment}"
  cluster = aws_ecs_cluster.fargate_cluster.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count = 1
  launch_type = "FARGATE"
  deployment_controller {
    type = "CODE_DEPLOY"
  }
  network_configuration {
    security_groups = [aws_security_group.fargate_cluster_ecs_sg.id]
    subnets = aws_subnet.fargate_cluster_subnets.*.id
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.blue.id
    container_name = "${var.application_name}-${var.environment}"
    container_port = var.container_port
  }

  # Workaround for https://github.com/hashicorp/terraform/issues/12634
  depends_on = [aws_lb_listener.primary]

  lifecycle {
    ignore_changes = [task_definition]
  }

  tags = var.tags
}

