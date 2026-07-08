terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# OPÇÃO A: DEPLOY NA AWS REAL
provider "aws" {
  region = "us-east-1"
}

# OPÇÃO B: DEPLOY NO LOCALSTACK (CONTINGÊNCIA)
# provider "aws" {
#   region                      = "us-east-1"
#   access_key                  = "mock"
#   secret_key                  = "mock"
#   skip_credentials_validation = true
#   skip_metadata_api_check     = true
#   skip_requesting_account_id  = true
#   endpoints {
#     ec2      = "http://localhost:4566"
#     s3       = "http://localhost:4566"
#     dynamodb = "http://localhost:4566"
#   }
# }

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP traffic"
  # vpc_id      = "vpc-xxxxxxxxxxxxxxxxx" # Substitua pelo ID da sua VPC

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0de716d6197524dd9" # Substitua pela AMI da sua região
  instance_type = "t2.micro"
  security_groups = [aws_security_group.allow_ssh_http.name]

  tags = {
    Name = "Terraform Example"
  }
}