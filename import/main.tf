provider "aws" {
  region = "us-east-1"
}

# 1
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
# terraform import aws_vpc.vpc-1 vpc-00de97630c29113a9
resource "aws_vpc" "vpc-1" {
  cidr_block = "10.20.0.0/16"

  tags = {
    Name = "vpc-1"
  }
}

# 2
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
# terraform import aws_subnet.subnet_private-1b subnet-0051f427778b1ff4d
resource "aws_subnet" "subnet_private-1b" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.20.244.0/22"

  tags = {
    Name = "subnet_private"
  }
}

# terraform import aws_subnet.subnet_private-1a subnet-0d5990ecf074bcb77
resource "aws_subnet" "subnet_private-1a" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.20.240.0/22"

  tags = {
    Name = "subnet_private"
  }
}

# terraform import aws_subnet.subnet_private_eks_1a subnet-034e6c4dc6317a452
resource "aws_subnet" "subnet_private_eks_1a" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.20.0.0/18"

  tags = {
    Name = "subnet_private_eks_1a"
  }
}

# terraform import aws_subnet.subnet_private_eks_1b subnet-0d9c4af225e62ae79
resource "aws_subnet" "subnet_private_eks_1b" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.20.64.0/18"

  tags = {
    Name = "subnet_private_eks_1b"
  }
}

# terraform import aws_subnet.subnet_private_eks_1c subnet-02a65b0d6bb339d8a
resource "aws_subnet" "subnet_private_eks_1c" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.20.128.0/18"

  tags = {
    Name = "subnet_private_eks_1c"
  }
}

# terraform import aws_subnet.subnet_public-1a subnet-06c1f638794e8e833
resource "aws_subnet" "subnet_public-1a" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.20.248.0/22"

  tags = {
    Name = "subnet_public"
  }
}

# terraform import aws_subnet.subnet_public-1b subnet-0c014be1241c5a5e6
resource "aws_subnet" "subnet_public-1b" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.20.252.0/22"

  tags = {
    Name = "subnet_public"
  }
}

# terraform import aws_subnet.subnet_public_eks_1a subnet-0ce66d14e57ed7dec
resource "aws_subnet" "subnet_public_eks_1a" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.20.192.0/20"

  tags = {
    Name = "subnet_public_eks_1a"
  }
}

# terraform import aws_subnet.subnet_public_eks_1b subnet-04a10bfd934641a2e
resource "aws_subnet" "subnet_public_eks_1b" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.20.208.0/20"

  tags = {
    Name = "subnet_public_eks_1b"
  }
}

# terraform import aws_subnet.subnet_public_eks_1c subnet-0ba9d8917ad94e03d
resource "aws_subnet" "subnet_public_eks_1c" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.20.224.0/20"

  tags = {
    Name = "subnet_public_eks_1c"
  }
}

# 3
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
# terraform import aws_internet_gateway.internet-gateway-01 igw-07155657988a293f8
resource "aws_internet_gateway" "internet-gateway-01" {
  vpc_id = aws_vpc.vpc-1.id

  tags = {
    Name = "internet-gateway-01"
  }
}

# 4
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
# terraform import aws_eip.nat_eip 34.195.83.150
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.internet-gateway-01]
}

# 5
# Main NAT Gateway for VPC
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
# terraform import aws_nat_gateway.nat nat-0320434e43c8a5081
resource "aws_nat_gateway" "nat-gateway-01" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet_public-1a.id

  tags = {
    Name = "nat-gateway-01"
  }
}

# # 6
# # Route Table for Public Subnet
# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table

# resource "aws_route_table" "public-rt" {
#   vpc_id = aws_vpc.vpc-1.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.internet-gateway-01
#   }

#   tags = {
#     Name = "public-rt"
#   }
# }

# # Association between Public Subnet and Public Route Table
# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
# resource "aws_route_table_association" "public" {
#   subnet_id      = aws_subnet.public.id
#   route_table_id = aws_route_table.public.id
# }

# # Route Table for Private Subnet
# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat.id
#   }

#   tags = {
#     Name = "private"
#   }
# }

# # Association between Private Subnet and Private Route Table
# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
# resource "aws_route_table_association" "private" {
#   subnet_id      = aws_subnet.private.id
#   route_table_id = aws_route_table.private.id
# }

# # 7
# #  Resource: aws_security_group
# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# resource "aws_security_group" "nginx" {
#   name        = "nginx"
#   description = "Access for Nginx"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     description = "Web Access"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "SSH Access"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # Resource: aws_instance
# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
# resource "aws_instance" "nginx" {
#   ami                    = "ami-0dba2cb6798deb6d8"
#   instance_type          = "t2.micro"
#   vpc_security_group_ids = [aws_security_group.nginx.id]
#   key_name               = "devops"

#   tags = {
#     Name = "Nginx"
#   }
# }

# # 8
# # Manages a Route53 Hosted Zone
# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone
# resource "aws_route53_zone" "devops" {
#   name    = "devopsbyexample.io"
#   comment = ""
# }

# # Provides a Route53 record resource
# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
# resource "aws_route53_record" "nginx" {
#   zone_id = aws_route53_zone.devops.zone_id
#   name    = "api.devopsbyexample.io"
#   type    = "A"
#   ttl     = "300"
#   records = [aws_instance.nginx.public_ip]
# }