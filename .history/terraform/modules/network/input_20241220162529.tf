variable "compartment_id" {
  description = "The OCID of the compartment to deploy the network resources."
  type        = string
}

variable "vcn_cidr_block" {
  description = "The CIDR block for the VCN."
  type        = string
}

variable "vcn_name" {
  description = "The name of the VCN."
  type        = string
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet."
  type        = string
}

variable "private_subnet_cidr" {
  description = "The CIDR block for the private subnet."
  type        = string
}

variable "availability_domain" {
  description = "The availability domain where the subnets will be created."
  type        = string
}

variable "internet_gateway_id" {
  description = "The OCID of the Internet Gateway for the public route table."
  type        = string
}

variable "nat_gateway_id" {
  description = "The OCID of the NAT Gateway for the private route table."
  type        = string
}

