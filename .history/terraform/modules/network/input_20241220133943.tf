variable "compartment_id" {}
variable "cidr_block" {}
variable "display_name" {}
variable "subnet_count" {
  default = 1
}
variable "subnet_cidrs" {
  type = list(string)
}
variable "availability_domain" {}