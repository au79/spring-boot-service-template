## CodeDeploy

resource "aws_codedeploy_app" "service_app" {
  name = "appECS-service-app-blue-green-${var.region}"
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "service_app" {
  deployment_group_name = "dgpECS-service-app-blue-green-${var.region}"
  app_name = aws_codedeploy_app.service_app.name
  service_role_arn = var.ecs_codedeploy_role_arn
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  auto_rollback_configuration {
    enabled = true
    events = ["DEPLOYMENT_FAILURE"]
  }
  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }
  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }
  ecs_service {
    cluster_name = aws_ecs_cluster.fargate_cluster.name
    service_name = aws_ecs_service.ecs_service.name
  }
  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_lb_listener.primary.arn]
      }
      target_group {
        name = aws_lb_target_group.blue.name
      }
      test_traffic_route {
        listener_arns = [aws_lb_listener.secondary.arn]
      }
      target_group {
        name = aws_lb_target_group.green.name
      }
    }
  }
}

