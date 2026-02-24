variable "aws_region" { type = string }

variable "ecr_repository_name" {
  type        = string
  description = "ECR repo name, e.g. cicd-lab/demo-app"
}

variable "ecr_keep_last_images" {
  type    = number
  default = 30
}

variable "jenkins_role_name" {
  type    = string
  default = "jenkins-ec2-role"
}

variable "instance_name" {
  type    = string
  default = "jenkins-ec2"
}

variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "key_name" {
  type        = string
  description = "Existing EC2 key pair name"
}

variable "allowed_ssh_cidrs" {
  type    = list(string)
  default = []
}

variable "allowed_jenkins_cidrs" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "azs" {
  type    = list(string)
  # us-east-1 examples
  default = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.10.0.0/24", "10.10.1.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.10.100.0/24", "10.10.101.0/24"]
}
variable "project_name" {
  type        = string
  description = "ecr"
}