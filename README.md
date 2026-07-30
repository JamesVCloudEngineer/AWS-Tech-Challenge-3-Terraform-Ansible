# Tech Challenge 3: Infrastructure as Code with Terraform and Ansible

**Author:** James Victor
**Project:** Cloud Engineer Coding Challenge 3

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

- terraform/ — main.tf, variables.tf, outputs.tf, terraform.tfvars
- ansible/ — inventory.ini, playbook.yml
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
- The security group is scoped to only SSH (22) and HTTP (80) — no unnecessary open ports.

## Results

Successfully provisioned and configured a fully working AWS environment from
scratch using Infrastructure as Code. The deployed EC2 instance served a live
"Hello, World!" page over HTTP, confirming end-to-end automation from
infrastructure provisioning through application deployment.

**Verification:**
- `terraform apply` created all resources without errors (EC2, S3, IAM
role/instance profile, security group)
- `ansible-playbook` completed with `changed=3, failed=0` — Nginx installed,
Hello World page deployed, service confirmed running and enabled
- Hello World page confirmed reachable via the EC2 public IP in a browser

*(Screenshots: terraform apply output, ansible-playbook recap, browser Hello
World page)*

## Design Decisions & Key Learnings

**Why split responsibilities between Terraform and Ansible?**
Terraform's job stops at "does the infrastructure exist" — it provisions the EC2
instance, networking, IAM, and storage. Ansible's job starts once that
infrastructure is live — it handles configuration state on the running server
(installing Nginx, deploying content, managing the service). Keeping these
separate mirrors how real teams divide provisioning from configuration
management, and it means either layer can be swapped or scaled independently
later.

**Why scope the security group to only SSH (22) and HTTP (80)?**
Following least-privilege principles — the instance only needs inbound access for
administration (SSH) and serving the web page (HTTP). No unnecessary ports were
opened, reducing the attack surface.

**Why exclude the .pem key and Terraform state files from version control?**
The private key grants direct SSH access to the instance, and Terraform state
files can contain sensitive resource metadata (IPs, IDs, sometimes secrets) in
plaintext. Both are excluded via `.gitignore` to prevent credential leakage in a
public or shared repo.

**Why a dynamic AMI lookup instead of a hardcoded AMI ID?**
Hardcoded AMI IDs are region-specific and go stale as new Ubuntu images are
released. A dynamic lookup (via a Terraform data source) ensures the latest
Ubuntu 24.04 image is always used, and the code stays portable across AWS
regions.

## What I'd Improve at Scale

- **Remote state backend:** Currently using local Terraform state; in a team
environment I'd move this to an S3 backend with DynamoDB state locking to prevent
conflicting applies and enable collaboration.
- **Dynamic Ansible inventory:** The current setup requires manually copying the
EC2 public IP into `inventory.ini` after each apply. At scale, I'd use
Terraform's output directly to generate a dynamic inventory file, removing that
manual step entirely.
- **Secrets management:** SSH key handling is currently manual and local. In
production, I'd use AWS Systems Manager Session Manager or Secrets Manager to
eliminate the need for a distributed `.pem` file altogether.
- **CI/CD integration:** This deployment is currently run manually from the
command line. Wiring this into a pipeline (Jenkins or GitHub Actions) would allow
`terraform plan` to run automatically on every pull request, with `apply` gated
behind manual approval.
