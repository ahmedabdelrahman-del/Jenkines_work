############################################
# ASSUME ROLE
############################################

data "aws_iam_policy_document" "assume_ec2" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_ec2.json
  tags               = var.tags
}

############################################
# ECR PUSH POLICY
############################################

data "aws_iam_policy_document" "ecr_push" {
  # Auth token must be *
  statement {
    sid       = "ECRAuthToken"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  # Push permissions on the repository
  statement {
    sid    = "ECRPushPullOnRepo"
    effect = "Allow"
    actions = [
      # push
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",

      # often needed by tooling during push/pull workflows
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",

      # metadata
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages"
    ]
    resources = [var.ecr_repo_arn]
  }
}

resource "aws_iam_policy" "this" {
  name   = "${var.role_name}-ecr"
  policy = data.aws_iam_policy_document.ecr_push.json
  tags   = var.tags
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

############################################
# INSTANCE PROFILE
############################################

resource "aws_iam_instance_profile" "this" {
  name = "${var.role_name}-instance-profile"
  role = aws_iam_role.this.name
  tags = var.tags
}


