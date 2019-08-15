## Application Load Balancer

resource "aws_lb" "spring_boot_service_lb" {
  name = "service-alb-${var.region}"
  load_balancer_type = "application"
  subnets = aws_subnet.fargate_cluster_subnets.*.id
  security_groups = [aws_security_group.fargate_cluster_alb_sg.id]

  tags = {
    project = "cd-pipeline"
  }
}

resource "aws_lb_target_group" "blue" {
  name = "service-alb-tg-blue-${var.region}"
  port = 5150
  protocol = "HTTP"
  vpc_id = aws_vpc.fargate_cluster_vpc.id
  target_type = "ip"
  
  tags = {
    project = "cd-pipeline"
  }
}

resource "aws_lb_target_group" "green" {
  name = "service-alb-tg-green-${var.region}"
  port = 5150
  protocol = "HTTP"
  vpc_id = aws_vpc.fargate_cluster_vpc.id
  target_type = "ip"

  tags = {
    project = "cd-pipeline"
  }
}

resource "aws_lb_listener" "primary" {
  load_balancer_arn = aws_lb.spring_boot_service_lb.id
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.blue.id
  }
}

resource "aws_lb_listener" "secondary" {
  load_balancer_arn = aws_lb.spring_boot_service_lb.id
  port = 8080
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.green.id
  }
}

