resource "aws_iam_role" "codebuild" {
  name               = "${var.namespace}-codebuild"
  assume_role_policy = file("./modules/iam/policies/codebuild-role.json")
}

resource "aws_iam_role" "codepipeline" {
  name               = "${var.namespace}-codepipeline"
  assume_role_policy = file("./modules/iam/policies/codepipeline-role.json")
}

resource "aws_iam_role_policy" "deploy" {
  count  = var.deployment_policy != null ? 1 : 0
  role   = aws_iam_role.codebuild.name
  policy = var.deployment_policy
}

