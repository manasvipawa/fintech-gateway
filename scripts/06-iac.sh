#!/usr/bin/env bash
# Task 6 - IaC: Terraform local_file creates payment.env, Ansible ad-hoc verifies it
source "$(dirname "$0")/lib.sh"
cd terraform

banner "TASK 6: TERRAFORM"
run 'cat main.tf'
run 'terraform init -input=false'
run 'terraform plan'
run 'terraform apply -auto-approve'

banner "VERIFY WITH ANSIBLE AD-HOC COMMAND"
run 'ansible localhost -m command -a "cat payment.env"'

banner "STATE CHECK (tfstate maps code to real infra)"
run 'terraform plan'

ok "Task 6 done: payment.env contains URL=http://localhost:30091"
