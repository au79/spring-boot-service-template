## CodePipeline

resource "aws_codepipeline" "service_pipeline" {
  name = "service-pipeline-${var.region}"
  role_arn = "arn:aws:iam::171154126783:role/service-role/AWSCodePipelineServiceRole-us-west-2-spring-boot-service"
  artifact_store {
    location = var.artifact_store_location
    type = var.artifact_store_type
  }
  stage {
    name = "Source"
    action {
      category = "Source"
      name = "DeploymentConfigSource"
      owner = "AWS"
      provider = "S3"
      version = "1"
      run_order = 1
      output_artifacts = ["DeploymentConfigArtifacts"]
      configuration = {
        PollForSourceChanges = false
        S3Bucket = var.deploy_config_bucket
        S3ObjectKey = var.deploy_config_object_key
      }
    }
    action {
      category = "Source"
      name = "ApplicationImageSource"
      owner = "AWS"
      provider = "ECR"
      version = "1"
      run_order = 1
      output_artifacts = ["ApplicationImageArtifact"]
      configuration = {
        ImageTag = var.ecr_image_tag
        RepositoryName = var.ecr_repository_name
      }
    }
  }
  stage {
    name = "Deploy"
    action {
      category = "Deploy"
      name = "Deploy"
      owner = "AWS"
      provider = "CodeDeployToECS"
      version = "1"
      run_order = 1
      input_artifacts = ["DeploymentConfigArtifacts", "ApplicationImageArtifact"]
      configuration = {
        ApplicationName = aws_codedeploy_app.service_app.name
        DeploymentGroupName = aws_codedeploy_deployment_group.service_app.deployment_group_name

        AppSpecTemplateArtifact = "DeploymentConfigArtifacts"
        AppSpecTemplatePath = var.app_spec_template_path
        TaskDefinitionTemplateArtifact = "DeploymentConfigArtifacts"
        TaskDefinitionTemplatePath = var.task_def_template_path
        Image1ArtifactName = "ApplicationImageArtifact"
        Image1ContainerName = var.task_def_image_placeholder

      }
    }
  }

  tags = {
    project = "cd-pipeline"
  }
}

