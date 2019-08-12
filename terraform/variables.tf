variable "region" {
  default = "us-west-1"
}

variable "az1" {
  default = "us-west-1c"
}

variable "az2" {
  default = "us-west-1b"
}

variable "ecr_repository_name" {
  default = "oolong/spring-boot-service"
}

variable "container_image_uri" {
  default = "171154126783.dkr.ecr.us-west-1.amazonaws.com/oolong/spring-boot-service:latest"
}

variable "task_execution_role_arn" {
  default = "arn:aws:iam::171154126783:role/ecsTaskExecutionRole"
}
