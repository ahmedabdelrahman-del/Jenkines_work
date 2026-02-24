# Jenkines_work
this repo has different CI Work
jenkins-key
# Delete the NAT Gateway
aws ec2 delete-nat-gateway --nat-gateway-id nat-04cbc83f38e74c16c --region us-east-1

# Wait for it to complete, then retry the destroy
terraform destroy -lock=false --auto-approve

rm -f terraform.tfstate terraform.tfstate.backup .terraform.tfstate.lock.info

# Re-init and apply with clean slate
terraform init -upgrade