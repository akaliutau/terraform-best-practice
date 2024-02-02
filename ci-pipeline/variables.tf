variable "source_code_repo" {
  type = object({ identifier = string, branch = string })
  description = "The pointer to the github repo with source code with TF templates of infrastructure to deploy"
}

variable "name" {
  type = string
  default = "tf-pipline"
  description = "The name of pipeline"
}