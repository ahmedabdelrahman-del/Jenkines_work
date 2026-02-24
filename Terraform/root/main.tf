provider "aws" {
  region = var.aws_region
}
module "ecr" {
  source           = "/workspaces/Jenkines_work/Terraform/modules/ecr"
  repository_name  = var.ecr_repository_name
  keep_last_images = var.ecr_keep_last_images
  tags             = var.tags
}

module "iam" {
  source       = "/workspaces/Jenkines_work/Terraform/modules/iam_jenkines_ecr"
  role_name    = var.jenkins_role_name
  ecr_repo_arn = module.ecr.repository_arn
  tags         = var.tags
}
############################################
# SSH KEY GENERATION
############################################

resource "tls_private_key" "jenkins" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "jenkins" {
  key_name   = "${var.project_name}-jenkins-key"
  public_key = tls_private_key.jenkins.public_key_openssh

  tags = var.tags
}

resource "aws_ssm_parameter" "jenkins_private_key" {
  name  = "/${var.project_name}/jenkins-private-key"
  type  = "SecureString"
  value = tls_private_key.jenkins.private_key_pem

  tags = var.tags
}

resource "local_file" "jenkins_private_key" {
  content         = tls_private_key.jenkins.private_key_pem
  filename        = "${path.module}/jenkins-key.pem"
  file_permission = "0400"
}

module "jenkins_ec2" {
  source                = "/workspaces/Jenkines_work/Terraform/modules/iam_jenkines_ec2"

  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnets[0]

  instance_name         = var.instance_name
  instance_type         = var.instance_type
  key_name              = aws_key_pair.jenkins.key_name
  allowed_ssh_cidrs     = var.allowed_ssh_cidrs
  allowed_jenkins_cidrs = var.allowed_jenkins_cidrs
  iam_instance_profile  = module.iam.instance_profile_name
  tags                  = var.tags
}
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.7"

  name = "${var.project_name}-vpc"
  cidr = var.vpc_cidr

  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.tags
}