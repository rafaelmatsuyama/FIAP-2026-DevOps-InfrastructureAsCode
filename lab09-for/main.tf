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

locals {
  instance_types = {
    web1 = "t2.micro"
    web2 = "t2.small"
    web3 = "t2.medium"
  }

  instance_list = [for name, type in local.instance_types : {
    name = name
    type = type
  }]
}

resource "aws_instance" "for_example" {
  for_each      = {for instance in local.instance_list : instance.name => instance}
  ami           = "ami-0de716d6197524dd9"
  instance_type = each.value.type

  tags = {
    Name = each.key
  }
}