# Input variable definitions
## VPC-1

variable "vpc-1-cidr" {
  description = "IPv4 CIDR"
}

variable "vpc-dnsSupport" {
  default = true
}

variable "vpc-dnsHostNames" {
  default = true
}