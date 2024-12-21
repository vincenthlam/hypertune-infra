resource "oci_core_vcn" "main_vcn" {
  cidr_block     = var.cidr_block
  display_name   = var.display_name
  compartment_id = var.compartment_id
}

resource "oci_core_subnet" "subnet" {
  count           = var.subnet_count
  cidr_block      = element(var.subnet_cidrs, count.index)
  vcn_id          = oci_core_vcn.main_vcn.id
  compartment_id  = var.compartment_id
  availability_domain = var.availability_domain
}