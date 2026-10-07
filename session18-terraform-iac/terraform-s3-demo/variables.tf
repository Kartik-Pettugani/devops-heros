variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region for infrastructure provisioning"
}

variable "bucket_name" {
  type        = string
  default     = "devops-hero-s3-demo-2026"
  description = "Globally unique name of the AWS S3 bucket"
}

variable "environment" {
  type        = string
  default     = "demo"
  description = "Target deployment environment tag"
}
---
output "s3_bucket_arn" {
  value       = aws_s3_bucket.demo_bucket.arn
  description = "Amazon Resource Name (ARN) of the created S3 bucket"
}

output "s3_bucket_name" {
  value       = aws_s3_bucket.demo_bucket.id
  description = "Name of the created S3 bucket"
}

output "s3_bucket_domain_name" {
  value       = aws_s3_bucket.demo_bucket.bucket_regional_domain_name
  description = "Regional FQDN domain name of the S3 bucket"
}
