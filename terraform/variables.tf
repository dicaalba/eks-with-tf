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
