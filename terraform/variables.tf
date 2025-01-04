variable "vpc_cidr" {
  description = "The CIDR range for the VPC"
  type        = string
}

variable "public_subnet_01_cidr" {
  description = "CIDR block for public subnet 01"
  type        = string
}

variable "public_subnet_02_cidr" {
  description = "CIDR block for public subnet 02"
  type        = string
}

variable "private_subnet_01_cidr" {
  description = "CIDR block for private subnet 01"
  type        = string
}

variable "private_subnet_02_cidr" {
  description = "CIDR block for private subnet 02"
  type        = string
}

# variables.tf

variable "key_name" {
  description = "Name of an existing EC2 KeyPair"
  type        = string
}

variable "public_key_material" {
  description = "The public key material"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.medium"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0261755bbcb8c4a84"  # Ubuntu 20.04 LTS
}
