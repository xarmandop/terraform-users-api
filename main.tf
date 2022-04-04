provider "aws" {
  region = "us-east-1"
  
}

#simple wat to define a var in tf
variable "subnect_cidr_block" {
  description = "subent cidr block"
  value = "10.0.10.0/24"
}

resource "aws_vpc" "altm-vpc" {
  tags = {
    Name = "alt-vpc"
  }
  cidr_block = "10.0.0.0/16"
}

#each subnet inside a VPC has to have a different set of IP address
resource "aws_subnet" "altm-subnet" { 
  tags = {
    Name = "altm-subnet"
  }
  vpc_id = aws_vpc.altm-vpc.id
  cidr_block = var.subnect_cidr_block.value
  availability_zone = "us-east-1a"
}

#Get an existing VPC 

data "aws_vpc" "default_vpc" {
  tags = {
    Name = "default-vpc"
  }
  default = true
}

# resource "aws_subnet" "altm-subnet-default-vpc" {
#   vpc_id = data.aws_vpc.default_vpc.id
#   cidr_block = "172.31.0.0/"
#   availability_zone = "us-east-1a"
# }

#chech outpust of resources
output "default-vpc-id" {
  value = data.aws_vpc.default_vpc.id
}


