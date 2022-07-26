# VPC Resources

resource "aws_vpc" "vpc-1" {
  cidr_block           = var.vpc-1-cidr
  enable_dns_support   = var.vpc-dnsSupport
  enable_dns_hostnames = var.vpc-dnsHostNames

  tags = {
    Name  = "vpc-1"
  }
}