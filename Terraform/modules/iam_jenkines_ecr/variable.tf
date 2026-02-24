############################################
# VARIABLES
############################################

variable "role_name" {
  type = string
}

variable "ecr_repo_arn" {
  type = string
}

variable "tags" {
  description = "Tags to apply to IAM resources."
  type        = map(string)
  default     = {}
}
