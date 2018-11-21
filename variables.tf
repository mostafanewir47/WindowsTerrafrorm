######### AWS Credentials #########

variable "aws_access_key_id" {
  description = "Please enter your access key"
}

variable "aws_secret_access_key" {
  description = "Please enter your AWS secret key"
}


######### Environment Variables #########

variable "aws_region" {
  description = "The region where the template will be run"
}

variable "AZ" {
  description = "The Availability Zone where the template will be run"
}

variable "name_tags" {
  description = "The name used to tag the resources"
}

variable "instance_type" {
  description = "The type of EC2 instance"
}

variable "key_name" {
  description = "The key name to be attached to the instance"
}

variable "ec2_subnet_id" {
  description = "The subnet where the instance will be launched in"
}

variable "vpc_id" {
  description = "The VPC where the deployment will be in"
}

variable "alb_public_subnet1_id" {
  description = "The first public subnet where the alb will be in"
}

variable "alb_public_subnet2_id" {
  description = "The second public subnet where the alb will be in"
}

variable "CertARN" {
  description = "The Amazon Resource Name of the Certificate"
}