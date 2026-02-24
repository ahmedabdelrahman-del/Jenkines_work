#!/bin/bash
cd /workspaces/Jenkines_work/Terraform/root
rm -f .terraform.tfstate.lock.info
terraform plan -lock=false 2>&1 | head -100
