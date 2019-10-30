variable "region" {
  default = "us-west-2"
}

variable "subnet_count" {
  default = 2
}

variable "ecr_repository_name" {
}

variable "ecr_image_tag" {
  default = "latest"
}

variable "container_image_uri" {
}

variable "task_execution_role_arn" {
}

variable "ecs_service_role_arn" {
}

variable "ecs_codedeploy_role_arn" {
}

variable "codebuild_service_role_arn" {
}

variable "artifact_store_type" {
}

variable "artifact_store_location" {
}

variable "deploy_config_bucket" {
}

variable "deploy_config_object_key" {
}

variable "app_spec_template_path" {
  default = "appspec.yml"
}

variable "task_def_template_path" {
  default = "taskdef.json"
}

variable "task_def_image_placeholder" {
  default = "IMAGE1_NAME"
}

variable "fargate_cpu" {
  default = "256"
}

variable "fargate_memory" {
  default = "512"
}

variable "container_port" {
}

variable "tags" {
  type = map(string)
}

variable "application_name" {
}

variable "environment" {
}

variable "source_location" {
}
