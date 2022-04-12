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
variable "local_ip" {}

resource "aws_vpc" "app-vpc" {
  tags = {
    Name = "${var.env_prefix}-vpc"
    description = "VPC for API users"
  }
  cidr_block = var.vpc_cidr_block
}

#Create new subent in default VPC
#each subnet inside a VPC has to have a different set of IP address
resource "aws_subnet" "app-subnet-1" { 
  tags = {
    Name = "${var.env_prefix}-subnet-1"
  }
  vpc_id = aws_vpc.app-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
}


#Create new a custom ROUTE TABLE
# resource "aws_route_table" "app-route-table" {
#   vpc_id = aws_vpc.app-vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id =  aws_internet_gateway.app-gateway.id
#   }

#   tags = {
#     Name: "${var.env_prefix}-rtb"
#   }
# }


#associate route table with a SUBNET created
# resource "aws_route_table_association" "ass-rtb-subnet" {
#   subnet_id = aws_subnet.app-subnet-1.id
#   route_table_id = aws_route_table.app-route-table.id
# }

#allowing internet traffic gateway = igt
resource "aws_internet_gateway" "app-gateway" {
  vpc_id = aws_vpc.app-vpc.id
  tags = {
    Name: "${var.env_prefix}-igw"
  }
}



#Get an existing VPC 
# data "aws_vpc" "default_vpc" {
#   tags = {
#     Name = "default-vpc"
#   }
#   default = true
# }

#Create a SUBNET in default VPC
# resource "aws_subnet" "app-default-vpc" {
#   vpc_id = data.aws_vpc.default_vpc.id
#   cidr_block = "172.31.0.0/"
#   availability_zone = "us-east-1a"
# }

#chech outpust of resources
# output "default-vpc-id" {
#   value = data.aws_vpc.default_vpc.id
# }






#WORK WITH DEFAULT ROUTE TABLE
resource "aws_default_route_table" "app-defaul-rtb" {
  default_route_table_id =  aws_vpc.app-vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id =  aws_internet_gateway.app-gateway.id
  }

  tags = {
    Name: "${var.env_prefix}-default-rtb"
  }
}

#WORK WITH DEFAULT SECURITY GROUP
#AWS by default close all port

resource "aws_default_security_group" "app-default-sg" {

  vpc_id = aws_vpc.app-vpc.id

  tags = {
    "Name" = "${var.env_prefix}-app-default-sg"
  }

  #ingres set a range of ports
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    #only my local IP address
    cidr_blocks = [var.local_ip]
  }

  #any can access the server through port 8080

    ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   egress {
    from_port = 8080
    to_port = 8080
    protocol = 0
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
   }
 
  
}

#CREATE A NEW SECURITY GROUP
#security group, rules to open port. to nginx, docker, etc
resource "aws_security_group" "app-sg" {
  name = "app-sg"
  vpc_id = aws_vpc.app-vpc.id

  tags = {
    "Name" = "${var.env_prefix}-app-sg"
  }

  #ingres set a range of ports
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    #only my local IP address
    cidr_blocks = [var.local_ip]
  }

  #any can access the server through port 8080

    ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   egress {
    from_port = 8080
    to_port = 8080
    protocol = 0
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
   }
  
}