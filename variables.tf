# EKS
variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "account_id" {
  description = "AWS target Account ID for assume_role mapping"
}