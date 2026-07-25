# Tech Challenge 3: Infrastructure as Code with Terraform and Ansible

**Author:** James Victor
**Bootcamp Deliverable:** Cloud Engineer Coding Challenge 3

## Objective

Provision AWS infrastructure using Terraform and configure it using Ansible, deploying a live "Hello, World!" web page.

## Architecture

- **Terraform** provisions: an EC2 instance (Ubuntu 24.04, t3.micro), an S3 bucket, an IAM role and instance profile, and a security group allowing SSH (22) and HTTP (80) traffic.
- **Ansible** connects to the provisioned EC2 instance via SSH and installs Nginx, then deploys a simple Hello World HTML page.

## Prerequisites

- AWS CLI installed and configured (aws configure)
- Terraform installed
- Ansible installed
- An existing EC2 key pair in your AWS account (james-project-key)

## Project Structure

- terraform/ - main.tf, variables.tf, outputs.tf, terraform.tfvars
- ansible/ - inventory.ini, playbook.yml
- .gitignore
- README.md

## Deployment Steps

### 1. Provision infrastructure with Terraform

cd terraform
terraform init
terraform plan
terraform apply

Confirm with yes when prompted. Terraform will output the EC2 instance public IP and DNS once complete.

### 2. Update the Ansible inventory

Copy the instance_public_ip value from the Terraform output and update ansible/inventory.ini, replacing REPLACE_WITH_EC2_PUBLIC_IP with the real IP address.

### 3. Configure the server with Ansible

cd ../ansible
ansible-playbook -i inventory.ini playbook.yml

### 4. Verify

Visit http://EC2_PUBLIC_IP in a browser to see the Hello World page.

## Cleanup

To avoid ongoing AWS charges, destroy all resources when done:

cd terraform
terraform destroy

## Security Notes

- The EC2 key pair (.pem file) is excluded from version control via .gitignore.
- Terraform state files are excluded from version control, as they can contain sensitive resource details.
- The security group is scoped to only SSH (22) and HTTP (80) - no unnecessary open ports.
