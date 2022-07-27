# Input variable definitions
## VPC-1

variable "vpc-1-cidr" {
  description = "IPv4 CIDR"
}

variable "subnets" {
    default = {
       subnet_private_eks_1a = {
          cidr_block = "10.20.0.0/18"
          availability_zone = "us-east-1a"
       }
       subnet_private_eks_1a = {
          cidr_block = "10.20.0.0/18"
          availability_zone = "us-east-1a"
       }
    }
} 