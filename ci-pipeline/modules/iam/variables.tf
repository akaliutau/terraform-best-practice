variable "namespace" {
  type        = string
  description = "A namespace for the project"
}

variable "deployment_policy" {
  type        = string
  default     = null
  description = "An optional IAM deployment policy"
}