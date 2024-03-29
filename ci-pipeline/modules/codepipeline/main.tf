locals {
  projects = ["plan", "apply"]
}

# describes the image for Runner on each step
# it can be a custom image
# Note, we are using the latest image from Hashicorp
resource "aws_codebuild_project" "project" {
  count        = length(local.projects)
  name         = "${var.namespace}-${local.projects[count.index]}"
  service_role = var.codebuild_role_arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "hashicorp/terraform:${var.terraform_version}"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "NO_SOURCE"
    buildspec = file("${path.module}/templates/buildspec_${local.projects[count.index]}.yml")
  }
}

locals {
  backend = templatefile("${path.module}/templates/backend.json", { config : var.s3_backend_config, name : var.namespace })

  default_environment = {
    TF_IN_AUTOMATION  = "1"
    TF_INPUT          = "0"
    CONFIRM_DESTROY   = "0"
    WORKING_DIRECTORY = var.working_directory
    BACKEND           = local.backend,
  }

  environment = jsonencode([for k, v in merge(local.default_environment, var.environment) : { name : k, value : v, type : "PLAINTEXT" }])
}

resource "aws_s3_bucket" "codepipeline" {
  bucket        = "${var.namespace}-codepipeline"
  acl           = "private"
  force_destroy = true
}

resource "aws_sns_topic" "codepipeline" {
  name = "${var.namespace}-codepipeline"
}

resource "aws_codestarconnections_connection" "github" {
  name          = "${var.namespace}-github"
  provider_type = "GitHub"
}

resource "aws_codepipeline" "codepipeline" {
  name     = "${var.namespace}-pipeline"
  role_arn = var.codepipeline_role_arn

  artifact_store {
    location = aws_s3_bucket.codepipeline.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        FullRepositoryId = var.source_code_repo.identifier
        BranchName       = var.source_code_repo.branch
        ConnectionArn    = aws_codestarconnections_connection.github.arn
      }
    }
  }

  stage {
    name = "Plan"

    action {
      name            = "Plan"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName          = aws_codebuild_project.project[0].name
        EnvironmentVariables = local.environment
      }
    }
  }

  dynamic "stage" {
    for_each = var.auto_apply ? [] : [1]
    content {
      name = "Approval"

      action {
        name     = "Approval"
        category = "Approval"
        owner    = "AWS"
        provider = "Manual"
        version  = "1"

        configuration = {
          CustomData      = "Please review output of plan and approve"
          NotificationArn = aws_sns_topic.codepipeline.arn
        }
      }
    }
  }

  stage {
    name = "Apply"

    action {
      name            = "Apply"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName          = aws_codebuild_project.project[1].name
        EnvironmentVariables = local.environment
      }
    }
  }
}
