
############################################
# VARIABLES
############################################

variable "instance_name" {
  description = "Name of the Jenkins EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.medium"
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB."
  type        = number
  default     = 30
}

variable "key_name" {
  description = "EC2 key pair name."
  type        = string
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed for SSH access."
  type        = list(string)
}

variable "allowed_jenkins_cidrs" {
  description = "CIDR blocks allowed for Jenkins (port 8080)."
  type        = list(string)
}

variable "iam_instance_profile" {
  description = "IAM instance profile name to attach to the instance."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID (optional). If null, use default VPC."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Subnet ID (optional). If null, pick a public subnet in the selected VPC."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags for resources."
  type        = map(string)
  default     = {}
}
