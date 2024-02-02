output "codebuild_role_arn" {
   value = aws_iam_role.codebuild.arn
}

output "codebuild_role_name" {
   value = aws_iam_role.codebuild.name
}

output "pipeline_role_arn" {
   value = aws_iam_role.codepipeline.arn
}

output "pipeline_role_name" {
   value = aws_iam_role.codepipeline.name
}
