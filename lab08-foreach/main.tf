terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" # Substitua pela sua região
}

variable "instance_names" {
  type = list(string)
  default = ["web1", "web2", "web3"]
}

resource "aws_instance" "foreach_example" {
  for_each      = toset(var.instance_names)
  ami           = "ami-0de716d6197524dd9"
  instance_type = "t2.micro"

  tags = {
    Name = each.value
  }
}