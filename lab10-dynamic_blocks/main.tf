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

resource "aws_instance" "example" {
  ami           = "ami-0de716d6197524dd9"
  instance_type = "t2.micro"

  dynamic "ebs_block_device" {
    for_each = var.ebs_volumes
    content {
      device_name           = ebs_block_device.value.device_name
      volume_size           = ebs_block_device.value.volume_size
      volume_type           = ebs_block_device.value.volume_type
      delete_on_termination = true
    }
  }
}

variable "ebs_volumes" {
  type = list(object({
    device_name = string
    volume_size = number
    volume_type = string
  }))
  # default = []
  default = [
    {
      device_name = "/dev/sdb"
      volume_size = 10
      volume_type = "gp2"
    },
    {
      device_name = "/dev/sdc"
      volume_size = 20
      volume_type = "gp2"
    }
  ]
}