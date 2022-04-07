provider "aws" {
  region = "us-east-1"  
}

#simple wat to define a var in tf
# variable "subnect_cidr_block" {
#   description = "subent cidr block"
#   value = "10.0.10.0/24"
# }

variable "avail_zone" {}
variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "env_prefix" {}

resource "aws_vpc" "app-vpc" {
  tags = {
    Name = "${var.env_prefix}-vpc"
    description = "VPC for API users"
  }
  cidr_block = var.vpc_cidr_block
}

#each subnet inside a VPC has to have a different set of IP address
resource "aws_subnet" "app-subnet-1" { 
  tags = {
    Name = "${var.env_prefix}-subnet-1"
  }
  vpc_id = aws_vpc.app-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
}

#Get an existing VPC 

# data "aws_vpc" "default_vpc" {
#   tags = {
#     Name = "default-vpc"
#   }
#   default = true
# }

# resource "aws_subnet" "altm-subnet-default-vpc" {
#   vpc_id = data.aws_vpc.default_vpc.id
#   cidr_block = "172.31.0.0/"
#   availability_zone = "us-east-1a"
# }

#chech outpust of resources
# output "default-vpc-id" {
#   value = data.aws_vpc.default_vpc.id
# }


