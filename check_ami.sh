#!/bin/bash

set -x

# Define variables
REGION="us-west-2"
AMI_NAME="Packer-terraform-ami"
PACKER_TEMPLATE="template.pkr.hcl"

# Get the AMI name
AMI_RESULT=$(aws ec2 describe-images \
    --region us-west-2 \
    --filters "Name=name,Values=$AMI_NAME" \
    --query "Images[0].ImageId" \
    --output text)

if [[ "$AMI_RESULT" == "$AMI_NAME" && -n "$AMI_RESULT" ]]; then
 echo " AMI '$AMI_NAME' found! Running Terraform..."

#change to terraform directory to run terraform commands

cd ec2-instance || { echo "Failed to enter Terraform directory"; exit 1; }
terraform init
terraform validate
terraform plan
terraform apply -auto-approve

else 

#[[ "$AMI_NAME" == "None" || -z "$AMI_NAME" ]]; then
 #  echo " $AMI_NAME not found...creating it with packer "
  
echo " AMI '$AMI_NAME' not found... Creating it with Packer"

# Change to Packer directory and run Packer

cd packer-terraform
echo " initializing packer"
packer init "$PACKER_TEMPLATE"

if ! packer validate "$PACKER_TEMPLATE"; then
echo "Packer validation failed!"
exit 1
fi

echo "Building AMI with Packer..."
packer build "$PACKER_TEMPLATE"
echo "✅ AMI successfully created!"

# Allow AWS to update its AMI list
sleep 10

# Move back to Terraform directory and run Terraform
cd ec2-instance || { echo "Failed to enter Terraform directory"; exit 1; }
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
fi