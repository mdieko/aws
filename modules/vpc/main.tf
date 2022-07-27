# VPC Resources

resource "aws_vpc" "vpc-1" {
  cidr_block           = var.vpc-1-cidr
  enable_dns_support   = var.vpc-dnsSupport
  enable_dns_hostnames = var.vpc-dnsHostNames

  tags = {
    Name  = "vpc-1"
  }
}

resource "aws_subnet" "subnet" {

  for_each = var.subnets

  availability_zone = each.value.availability_zone
  vpc_id = aws_vpc.vpc-homework2.id
  cidr_block = each.value.cidr_block
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
}