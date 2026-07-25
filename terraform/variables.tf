variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the existing EC2 key pair to use for SSH access"
  type        = string
  default     = "james-project-key"
}

variable "bucket_name" {
  description = "Globally unique name for the S3 bucket"
  type        = string
  default     = "aws-tech-challenge-3-jamesvictor-tfstate"
}

variable "project_name" {
  description = "Name tag prefix for all resources"
  type        = string
  default     = "tech-challenge-3"
}

