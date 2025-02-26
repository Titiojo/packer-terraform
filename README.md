Packer-Terraform AMI Deployment Script

Overview

This repository contains a Bash script that automates the deployment of an AWS EC2 instance using Packer and Terraform. The script checks for the existence of an Amazon Machine Image (AMI) named Packer-terraform-ami in the us-west-2 region.

If the AMI exists, the script runs Terraform to create a t2.micro instance.
If the AMI does not exist, the script creates the AMI using Packer, then deploys the instance with Terraform.
Prerequisites

Before running the script, ensure you have the following installed:

AWS CLI (configured with appropriate permissions)
Terraform
Packer
Bash Shell (Linux/macOS or Git Bash on Windows)
IAM Permissions
Ensure your AWS IAM user/role has the necessary permissions to:

Describe AMIs
Create and register AMIs
Launch EC2 instances
Manage Terraform infrastructure
