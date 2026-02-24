############################################
# DATA
############################################

locals {
  effective_vpc_id = var.vpc_id
}

# Amazon Linux 2023 AMI (x86_64), most recent
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

############################################
# SECURITY GROUP
############################################

resource "aws_security_group" "this" {
  name        = "${var.instance_name}-sg"
  description = "Security group for Jenkins"
  vpc_id      = local.effective_vpc_id

  ingress {
    description = "Jenkins UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.allowed_jenkins_cidrs
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

############################################
# EC2 INSTANCE
############################################

resource "aws_instance" "this" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.this.id]

  key_name             = var.key_name
  iam_instance_profile = var.iam_instance_profile

  associate_public_ip_address = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = var.root_volume_size
  }

  user_data = base64encode(<<-USERDATA
    #!/bin/bash
    set -euxo pipefail

    dnf update -y
    dnf install -y docker

    systemctl enable docker
    systemctl start docker

    mkdir -p /opt/jenkins_home
    chown -R 1000:1000 /opt/jenkins_home

    docker rm -f jenkins || true
    docker run -d --name jenkins \
      --restart=unless-stopped \
      -p 8080:8080 -p 50000:50000 \
      -v /opt/jenkins_home:/var/jenkins_home \
      -v /var/run/docker.sock:/var/run/docker.sock \
      jenkins/jenkins:lts-jdk17
  USERDATA
  )

  tags = merge(var.tags, { Name = var.instance_name })
}