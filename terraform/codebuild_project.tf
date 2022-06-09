resource "aws_codebuild_project" "codebuild" {
  depends_on = [
    aws_codecommit_repository.source_repo,
    aws_ecr_repository.image_repo
  ]
  name          = "codebuild-${var.source_repo_name}-${var.source_repo_branch}"
  service_role  = aws_iam_role.codebuild_role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "aws/codebuild/standard:3.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"
    environment_variable {
      name = "REPOSITORY_URI"
      value = aws_ecr_repository.image_repo.repository_url
    }
    environment_variable {
      name = "AWS_DEFAULT_REGION"
      value = var.aws_region
    }
    environment_variable {
      name = "CONTAINER_NAME"
      value = var.family
    }
  }
  source {
    type = "CODEPIPELINE"
    buildspec = <<BUILDSPEC
version: 0.2

phases:
  install:
    runtime-versions:
      python: 3.8
    commands:
      # Install Python packages
      - pip install --requirement requirements.txt

  pre_build:
    commands:
      # Validate Python code against coding style (aka PEP8) and programming errors
      - flake8

      # Validate Python code against coding style (aka PEP8), programming errors, and cyclomatic complexity
      - flake8 --max-complexity 10

      # Run unit tests
      - pytest
BUILDSPEC
  }
}
