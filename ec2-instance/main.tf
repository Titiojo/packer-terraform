terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "EC2" {
  ami           = data.aws_ami.terraform_ami.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.key_pair.key_name


  depends_on = [ aws_key_pair.key_pair ]

tags = {
    Name = "First-EC2"
  }
}

resource "aws_key_pair" "key_pair" {
  key_name   = "devkey"
  public_key = file("/Users/titilopeadewumi/key.pub")

}

# add datasource for for terraform to use the latest ami created

data "aws_ami" "terraform_ami" {
  most_recent = true

  owners = ["self"]
  
  filter {
    name   = "tag:Name"
    values = ["terraform-instance"]
  }

}