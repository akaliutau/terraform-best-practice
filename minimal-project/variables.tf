variable "account_id" {
  description = "The id of account"
  default     = "508030803329"
  type        = string
}

variable "ssh-key" {
  description = "The path to public ssh key to access AWS instances"
  default = "id_rsa_aws.pub"
  type = string
}

variable "cidr_block" {
  description = "CIDR Block"
  default = "10.0.0.0/24" # 172.31.32.0/20
  type = string
}

variable "availability_zone"{
  description = "Availability Zones for the Subnet"
  default = "us-east-1a"
  type = string
}

variable "region" {
  description = "Region for vpc"
  default = "us-east-1"
  type = string
}