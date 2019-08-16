## EC2

### Network

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "fargate_cluster_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = var.tags
}

resource "aws_internet_gateway" "fargate_cluster_igw" {
  vpc_id = aws_vpc.fargate_cluster_vpc.id

  tags = var.tags
}

resource "aws_route_table" "fargate_cluster_route_table" {
  vpc_id = aws_vpc.fargate_cluster_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.fargate_cluster_igw.id
  }

  tags = var.tags
}

resource "aws_subnet" "fargate_cluster_subnets" {
  count = var.subnet_count
  cidr_block = cidrsubnet(aws_vpc.fargate_cluster_vpc.cidr_block, 8, count.index)
  vpc_id = aws_vpc.fargate_cluster_vpc.id
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = var.tags
}

resource "aws_route_table_association" "fc_rt_association" {
  count = var.subnet_count
  route_table_id = aws_route_table.fargate_cluster_route_table.id
  subnet_id = aws_subnet.fargate_cluster_subnets.*.id[count.index]
}

### Security

resource "aws_security_group" "fargate_cluster_alb_sg" {
  name = "fargate_cluster_alb_sg"
  vpc_id = aws_vpc.fargate_cluster_vpc.id

  tags = var.tags
}

resource "aws_security_group_rule" "fargate_cluster_alb_sg_rule_port80" {
  description = "Inbound TCP traffic on port 80"
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.fargate_cluster_alb_sg.id
}

resource "aws_security_group_rule" "fargate_cluster_alb_sg_rule_port8080" {
  description = "Inbound TCP traffic on port 8080"
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.fargate_cluster_alb_sg.id
}

resource "aws_security_group" "fargate_cluster_ecs_sg" {
  name = "fargate_cluster_ecs_sg"
  vpc_id = aws_vpc.fargate_cluster_vpc.id

  tags = var.tags
}

resource "aws_security_group_rule" "direct_container_access" {
  description = "Public access to containers"
  type = "ingress"
  from_port = 5150
  to_port = 5150
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.fargate_cluster_ecs_sg.id
}

resource "aws_security_group_rule" "fargate_cluster_ecs_sg_ingress_rule" {
  description = "All inbound TCP traffic"
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  security_group_id = aws_security_group.fargate_cluster_ecs_sg.id
  source_security_group_id = aws_security_group.fargate_cluster_alb_sg.id
}

resource "aws_security_group_rule" "fargate_cluster_ecs_sg_egress_rule" {
  description = "All outbound traffic"
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.fargate_cluster_ecs_sg.id
}
