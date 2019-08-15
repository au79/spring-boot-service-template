## ECS

resource "aws_ecs_task_definition" "spring-boot-service-taskdef" {
  family = "spring-boot-service-taskdef"
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
      "secretOptions": null,
      "options": {
        "awslogs-group": "/ecs/spring-boot-service-taskdef",
        "awslogs-region": "us-west-1",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "portMappings": [
      {
        "hostPort": 5150,
        "protocol": "tcp",
        "containerPort": 5150
      }
    ],
    "image": "${var.container_image_uri}",
    "name": "spring-boot-service-container",
    "cpu" : ${var.fargate_cpu},
    "memory": ${var.fargate_memory}
  }
]
DEFINITION

  tags = {
    project = "cd-pipeline"
  }
}

resource "aws_ecs_cluster" "fargate_cluster" {
  name = "fargate-cluster-${var.region}"
  tags = {
    project = "cd-pipeline"
  }
}

resource "aws_ecs_service" "ecs_service" {
  name = "blue-green-service-${var.region}"
  cluster = aws_ecs_cluster.fargate_cluster.id
  task_definition = aws_ecs_task_definition.spring-boot-service-taskdef.arn
  desired_count = 1
  launch_type = "FARGATE"
  load_balancer {
    target_group_arn = aws_lb_target_group.blue.id
    container_name = "spring-boot-service-container"
    container_port = 5150
  }
  tags = {
    project = "cd-pipeline"
  }
}

