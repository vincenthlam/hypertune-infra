variable "compartment_id" {
  description = "OCI compartment ID"
}

variable "availability_domain" {
  description = "Availability domain for resources"
}

variable "image_id" {
  description = "Image ID for compute instances"
}

variable "ssh_public_key" {
  description = "SSH public key for instance access"
}

variable "internet_gateway_id" {
  description = "The OCID of the Internet Gateway."
  type        = string
}

variable "nat_gateway_id" {
  description = "The OCID of the NAT Gateway."
  type        = string
}