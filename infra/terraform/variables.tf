variable "aws_region" {
    description = "AWS region to deploy into"
    type = string
    default = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance size"
  type = string
  default = "t3.micro"
}

variable "key_name" {
  description = "Name for SSH key pair"
  type = string
  default = "todo-ops-key"
}