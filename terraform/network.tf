# Specify the provider and access details
provider "aws" {
  profile    = "default"
  region     = var.region
}

## EC2

### Network

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "fargate_cluster_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    project = "cd-pipeline"
  }
}

resource "aws_internet_gateway" "fargate_cluster_igw" {
  vpc_id = aws_vpc.fargate_cluster_vpc.id

  tags = {
    project = "cd-pipeline"
  }
}

resource "aws_route_table" "fargate_cluster_route_table" {
  vpc_id = aws_vpc.fargate_cluster_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.fargate_cluster_igw.id
  }

  tags = {
    project = "cd-pipeline"
  }
}

resource "aws_subnet" "fargate_cluster_subnets" {
  count = var.subnet_count
  cidr_block = cidrsubnet(aws_vpc.fargate_cluster_vpc.cidr_block, 8, count.index)
  vpc_id = aws_vpc.fargate_cluster_vpc.id
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    project = "cd-pipeline"
  }
}

resource "aws_route_table_association" "fc_rt_association" {
  count = var.subnet_count
  route_table_id = aws_route_table.fargate_cluster_route_table.id
  subnet_id = aws_subnet.fargate_cluster_subnets.*.id[count.index]
}

### Security

resource "aws_security_group" "fargate_cluster_alb_sg" {
  vpc_id = aws_vpc.fargate_cluster_vpc.id

  tags = {
    project = "cd-pipeline"
  }
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

  tags = {
    project = "cd-pipeline"
  }
}

resource "aws_security_group_rule" "fargate_cluster_ecs_sg_rule" {
  from_port = 0
  protocol = "tcp"
  security_group_id = aws_security_group.fargate_cluster_ecs_sg.id
  to_port = 65535
  type = "ingress"
  source_security_group_id = aws_security_group.fargate_cluster_alb_sg.id
}
