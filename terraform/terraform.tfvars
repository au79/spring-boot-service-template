environment = "dev"

region = "us-west-2"

artifact_store_type = "S3"
artifact_store_location = "codepipeline-us-west-2-885847999191"
deploy_config_bucket = "com.oolong.build-artifacts.us-west-2"
deploy_config_object_key = "spring-boot-service-deploy-specs.zip"

ecr_repository_name = "oolong/spring-boot-service"
container_image_uri = "171154126783.dkr.ecr.us-west-2.amazonaws.com/oolong/spring-boot-service:latest"

task_execution_role_arn = "arn:aws:iam::171154126783:role/ecsTaskExecutionRole"
ecs_service_role_arn = "arn:aws:iam::171154126783:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
ecs_codedeploy_role_arn = "arn:aws:iam::171154126783:role/ecsCodeDeployRole"
codebuild_service_role_arn = "arn:aws:iam::171154126783:role/service-role/CodeBuild-Service-Role"

app_spec_template_path = "appspec.json"

application_name = "spring-boot-service"
container_port = 5150
tags = {
  environment = "dev"
  project = "cd-pipeline"
}

source_location = "https://github.com/au79/spring-boot-service-template.git"

