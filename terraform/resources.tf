provider "aws" {
  profile    = "default"
  region     = var.region
}

resource "aws_vpc" "fargate_cluster_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "fargate_cluster_igw" {
  vpc_id = aws_vpc.fargate_cluster_vpc.id
}

resource "aws_route_table" "fargate_cluster_route_table" {
  vpc_id = aws_vpc.fargate_cluster_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.fargate_cluster_igw.id
  }
}

resource "aws_subnet" "fargate_cluster_subnet1" {
  cidr_block = "10.0.0.0/24"
  vpc_id = aws_vpc.fargate_cluster_vpc.id
  availability_zone = var.az1

}

resource "aws_subnet" "fargate_cluster_subnet2" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.fargate_cluster_vpc.id
  availability_zone = var.az2
}

resource "aws_route_table_association" "fargate_cluster_rta1" {
  route_table_id = aws_route_table.fargate_cluster_route_table.id
  subnet_id = aws_subnet.fargate_cluster_subnet1.id
}

resource "aws_route_table_association" "fargate_cluster_rta2" {
  route_table_id = aws_route_table.fargate_cluster_route_table.id
  subnet_id = aws_subnet.fargate_cluster_subnet2.id
}

resource "aws_security_group" "fargate_cluster_alb_sg" {
  vpc_id = aws_vpc.fargate_cluster_vpc.id
}

resource "aws_security_group_rule" "fargate_cluster_alb_sg_rule_port80" {
  from_port = 80
  protocol = "tcp"
  security_group_id = aws_security_group.fargate_cluster_alb_sg.id
  to_port = 80
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "fargate_cluster_alb_sg_rule_port8080" {
  from_port = 8080
  protocol = "tcp"
  security_group_id = aws_security_group.fargate_cluster_alb_sg.id
  to_port = 8080
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "fargate_cluster_ecs_sg" {
  vpc_id = aws_vpc.fargate_cluster_vpc.id
}

resource "aws_security_group_rule" "fargate_cluster_ecs_sg_rule" {
  from_port = 0
  protocol = "tcp"
  security_group_id = aws_security_group.fargate_cluster_ecs_sg.id
  to_port = 65535
  type = "ingress"
  source_security_group_id = aws_security_group.fargate_cluster_alb_sg.id
}

resource "aws_ecs_task_definition" "spring-boot-service-taskdef" {
  name = "spring-boot-service-taskdef_${var.region}"

  container_definitions = file("container-definitions.json")
  family = "spring-boot-service-taskdef"
  execution_role_arn = var.task_execution_role_arn
}

resource "aws_ecs_cluster" "fargate_cluster" {
  name = "fargate_cluster_${var.region}"
}

resource "aws_alb" "spring_boot_service_lb" {
  name = "spring_boot_service_alb_${var.region}"
  
}



resource "aws_ecs_service" "ecs_service" {
  name = "spring-boot-service-blue-green_${var.region}"
  cluster = aws_ecs_cluster.fargate_cluster.id
  task_definition = aws_ecs_task_definition.spring-boot-service-taskdef.arn
  desired_count = 1
  launch_type = "FARGATE"
  load_balancer {
    container_name = "spring-boot-service-container"
    container_port = 5150
  }
}

