## CodeBuild

resource "aws_codebuild_project" "service_app" {
  name = "${var.application_name}-${var.region}"
  service_role = "${var.codebuild_service_role_arn}"
  
  source {
    type = "GITHUB"
    location = "${var.source_location}"
    git_clone_depth = 1
    report_build_status = true
    insecure_ssl = false
  }
  
  artifacts {
    type ="S3"
    location = "${var.deploy_config_bucket}"
    path = ""
    namespace_type = "NONE"
    name = "${var.application_name}"
    packaging = "NONE"
    override_artifact_name = false
    encryption_disabled = false
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/standard:2.0"
    type = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode = true
  }

}

resource "aws_codebuild_webhook" "service_app" {
  project_name = "${aws_codebuild_project.service_app.name}"

  filter_group {
    filter {
      type = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type = "HEAD_REF"
      pattern = "^refs/heads/master$"
    }
  }
}

