variable "compartment_id" {}
variable "availability_domain" {}
variable "subnet_id" {}
variable "image_id" {}
variable "ssh_public_key" {}
variable "instance_count" {
  default = 1
}
variable "tags" {
  default = {}
}