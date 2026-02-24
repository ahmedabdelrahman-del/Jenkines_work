output "jenkins_url" {
  value = module.jenkins_ec2.jenkins_url
}

output "jenkins_public_ip" {
  value = module.jenkins_ec2.public_ip
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "iam_instance_profile_name" {
  value = module.iam.instance_profile_name
}

output "jenkins_key_name" {
  value = aws_key_pair.jenkins.key_name
}

output "jenkins_key_ssm_parameter" {
  value       = aws_ssm_parameter.jenkins_private_key.name
  description = "SSM Parameter Store path for Jenkins private key"
}

output "jenkins_key_pem_file" {
  value       = local_file.jenkins_private_key.filename
  description = "Local path to Jenkins private key (DO NOT commit)"
}
